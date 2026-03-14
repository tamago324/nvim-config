-- tsserver の機能を使って、ファイル名を変更する
-- 単純なバージョン
-- https://github.com/typescript-language-server/typescript-language-server#workspace-commands-workspaceexecutecommand

-- From typescript.nvim
-- https://github.com/jose-elias-alvarez/typescript.nvim/blob/1add655c7ecf1f61df9a40b43973b0394d9ae9c4/src/rename-file.ts#L1

local lir = require("lir")
local actions = require("lir.actions")
local uv = vim.loop

local execute_command_rename_file = function(client, source, target)
  pprint(source, target)
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

local get_client = function(bufnr)
	local clients = vim.lsp.buf_get_clients(bufnr) or {}
	local tsserver_clients = vim.tbl_filter(function(client)
		return client.name == "tsserver"
	end, clients)

	if vim.tbl_isempty(tsserver_clients) then
		return nil
	end

	return tsserver_clients[1]
end

local load_bufnr = function()
	local ctx = lir.get_context()
	local bufnr = vim.fn.bufadd(ctx:current().fullpath)
	vim.fn.bufload(bufnr)

	return bufnr
end

local rename = function()
	-- bufadd することで server を起動する
	local source_bufnr = load_bufnr()
	local client = get_client(source_bufnr)

	if client == nil then
		-- 対象のファイルのワークスペースの tsserver が起動していないため、もう少し後で実行してー
		-- print('tsserver を起動中です。少し経ってから再度実行してください。')
		-- return

		vim.wait(500)

		-- 起動したと思うから、もう一度取得する
		client = get_client(source_bufnr)
	end

	local ctx = lir.get_context()
	local source = ctx:current().fullpath
	local target = nil

	vim.ui.input({
		prompt = "New path: ",
		default = source,
		completion = "file",
	}, function(input)
		if input == "" or input == source then
			return
		end

		target = input
	end)

	if target == nil then
		-- キャンセル
		return
	end

	execute_command_rename_file(client, source, target)

	-- XXX: 変更されたままのバッファは削除できないため？
	if vim.api.nvim_buf_get_option(source_bufnr, "modified") then
		vim.api.nvim_buf_call(source_bufnr, function()
			vim.cmd("w!")
		end)
	end

	-- ファイル名の変更は独自で実行する必要があるらしい
	if not uv.fs_rename(source, target) then
		print("Rename failed")
	end

	actions.reload()

	-- ウィンドウに設定する
	local target_bufnr = vim.fn.bufadd(target)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == source_bufnr then
			vim.api.nvim_win_set_buf(win, target_bufnr)
		end
	end

	vim.schedule(function()
		vim.api.nvim_buf_delete(source_bufnr, { force = true })
	end)
end

return {
	rename = rename,
}
