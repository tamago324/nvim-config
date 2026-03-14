-- tsserver の機能を使って、ファイル名を変更する
-- https://github.com/typescript-language-server/typescript-language-server#workspace-commands-workspaceexecutecommand

-- From typescript.nvim
-- https://github.com/jose-elias-alvarez/typescript.nvim/blob/1add655c7ecf1f61df9a40b43973b0394d9ae9c4/src/rename-file.ts#L1

local lir = require("lir")
local actions = require("lir.actions")
local uv = vim.loop
local input = require("xlir.nui.input").input
local util = require("lspconfig.util")
local Path = require("plenary.path")
local ROOT = Path.path.root

local execute_command_rename_file = function(client, source, target)
	client.request("workspace/executeCommand", {
		command = "_typescript.applyRenameFile",
		arguments = {
			{
				sourceUri = vim.uri_from_fname(source),
				targetUri = vim.uri_from_fname(target),
			},
		},
	})
end

--- 指定のパスに対応するサーバーの client を取得する
---@param base_path string ファイルのパス or ディレクトリのパス
---@return any client
local get_client = function(base_path)
	-- tsserver の client だけを取得
	local tsserver_clients = vim.tbl_filter(function(client)
		return client.name == "tsserver"
	end, vim.lsp.get_active_clients())

	local p = Path:new(base_path)
	local dir = (p:is_dir() and base_path) or p:parent():absolute()

	local client = nil
	for _, _client in ipairs(tsserver_clients) do
		if vim.startswith(dir, _client.config.root_dir) then
			client = _client
			break
		end
	end

	return client
end

local load_bufnr = function(path)
	local bufnr = vim.fn.bufadd(path)
	vim.fn.bufload(bufnr)
	return bufnr
end

--- rename を実行する
---@param source string 変更元ファイルのパス
---@param target string 変更後ファイルのパス
---@param source_bufnr number? 変更前ファイルのバッファ
local _do_rename = function(source, target, source_bufnr)
	-- XXX: 変更されたままのバッファは削除できないため？
	if source_bufnr and vim.api.nvim_buf_is_valid(source_bufnr) then
		if vim.api.nvim_buf_get_option(source_bufnr, "modified") then
			vim.api.nvim_buf_call(source_bufnr, function()
				vim.cmd("w!")
			end)
		end
	end

	-- ファイル名の変更は独自で実行する必要があるらしい
	if not uv.fs_rename(source, target) then
		print("Rename failed")
		return
	end

	actions.reload()

	-- ウィンドウに設定する
	local target_bufnr = vim.fn.bufadd(target)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == source_bufnr then
			vim.api.nvim_win_set_buf(win, target_bufnr)
		end
	end

	if source_bufnr and vim.api.nvim_buf_is_valid(source_bufnr) then
		vim.schedule(function()
			vim.api.nvim_buf_delete(source_bufnr, { force = true })
		end)
	end
end

--- rename する (ディレクトリにも対応)
local rename = function()
	-- bufadd することで server を起動する
	local source_path = lir.get_context():current().fullpath
	local source_bufnr = load_bufnr(source_path)
	local client = get_client(source_path)

	if client == nil then
		vim.wait(500)

		-- 起動したと思うから、もう一度取得する
		client = get_client(source_path)
		if client == nil then
			print("tsserver を起動中です。少し経ってから再度実行してください。")
			return
		end
	end

	local ctx = lir.get_context()
	local source = ctx:current()

	-- Promise.new(function(resolve)
	input({
		title = "Rename (TS)",
		border_color = "blue",
		default_value = source.value,
		on_submit = function(new)
			if new == nil then
				-- キャンセル
				return
			end
			local target_path = ctx.dir .. new
			execute_command_rename_file(client, source_path, target_path)
			_do_rename(source_path, target_path, source_bufnr)
		end,
	})
end

---WorkspaceEdit を Location のリストに変換する
local workspace_edit_to_location_list = function(workspace_edit)
	-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspaceEdit

	local all_changes = workspace_edit.changes
	if not (all_changes and not vim.tbl_isempty(all_changes)) then
		return {}
	end
	pprint(all_changes)

	local locations = {}
	for uri, changes in pairs(all_changes) do
		for _, change in ipairs(changes) do
			table.insert(locations, {
				filename = vim.uri_to_fname(uri),
				lnum = change.range.start.line + 1,
				col = change.range.start.character,
				end_col = change.range["end"].character,
				text = change.new_text,
				valid = true,
			})
		end
	end

	return locations
end

---qflist を空にして、ID を取得する
---@return any
local getqflist_id = function()
	-- 新しい qflist を作成する
	vim.fn.setqflist({}, " ")
	return vim.fn.getqflist({ id = 0 }).id
end

---qflist の重複しているアイテムを削除する
---@return table
local remove_duplicate_qflist_items = function()
	local qflist = vim.fn.getqflist()
	local map = {}
	for _, item in ipairs(qflist) do
		map[item.bufnr .. item.col .. item.lnum] = item
	end

	return vim.tbl_values(map)
end

---変更箇所を quickfix に出力する
--- :cfdo を使ってファイルを保存とかできる
---@param qflist_id number getqflist('id') で取得した qflist の ID
local change_workspace_applyedit_handler = function(qflist_id)
	local old_handler = vim.deepcopy(vim.lsp.handlers["workspace/applyEdit"])

	vim.lsp.handlers["workspace/applyEdit"] = function(_, workspace_edit, ctx)
		-- workspace_edit を qflist で使える形式に変換する
		-- Location のリストに変換する必要がある
		local locations = workspace_edit_to_location_list(workspace_edit.edit)

		-- apply_text を実行する前にバッファにロードしておく必要がある？
		for _, location in ipairs(locations) do
			-- バッファをロードする必要がある
			local bufnr = load_bufnr(location.filename)
			if not vim.fn.bufloaded(bufnr) then
				vim.fn.bufload(bufnr)
			end
		end

		-- https://github.com/neovim/neovim/blob/1facad23473eb2d045fe77199b3b0b9fd2586895/runtime/lua/vim/lsp/handlers.lua#L114
		-- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#workspace_applyEdit
		local result = old_handler(_, workspace_edit, ctx)

		-- 指定のqflistに追加していく
		vim.fn.setqflist({}, "a", {
			id = qflist_id,
			items = locations,
		})

		-- 重複したものを削除してセットする
		vim.fn.setqflist({}, "r", {
			id = qflist_id,
			items = remove_duplicate_qflist_items(),
		})

		-- 戻す
		vim.schedule(function()
			vim.lsp.handlers["workspace/applyEdit"] = old_handler
		end)

		return result
	end
end

return {
	rename = rename,
	get_client = get_client,
	load_bufnr = load_bufnr,
	getqflist_id = getqflist_id,
	change_workspace_applyedit_handler = change_workspace_applyedit_handler,
	execute_command_rename_file = execute_command_rename_file,
}
