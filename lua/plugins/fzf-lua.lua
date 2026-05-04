if vim.api.nvim_call_function("FindPlugin", { "fzf-lua" }) == 0 then
	do
		return
	end
end

local fzf = require("fzf-lua")

fzf.setup({
	keymap = {
		-- -- builtin は fzf-lua 自身の挙動を制御するキー設定です
		-- builtin = {
		-- 	["<C-s>"] = "toggle-preview",
		-- },
	},
})

vim.keymap.set("n", "<Space>fo", function()
	-- vim.cmd("FzfLua lsp_workspace_symbols")
	require("fzf-lua").lsp_workspace_symbols({
		winopts = {
			-- float の位置とサイズ
			height = 0.85,
			width = 0.80,
			row = 0.5, -- 垂直方向中央
			col = 0.5, -- 水平方向中央
			-- プレビューの設定
			preview = {
				layout = "vertical", -- 垂直配置
				vertical = "up:50%", -- プレビューを「上」に 50%
			},
		},
		fzf_opts = {
			["--layout"] = "reverse",
		},
	})
end)

vim.keymap.set("n", "<Space>ff", function()
	fzf.git_files({
		winopts = {
			-- float の位置とサイズ
			height = 0.85,
			width = 0.80,
			row = 0.5, -- 垂直方向中央
			col = 0.5, -- 水平方向中央
			-- プレビューの設定
			preview = {
				layout = "vertical", -- 垂直配置
				vertical = "up:50%", -- プレビューを「上」に 50%
			},
		},
		fzf_opts = {
			["--layout"] = "reverse",
		},
	})
end)

vim.keymap.set("n", "<Space>rf", require("refactoring").select_refactor)

vim.keymap.set("n", "<Space>ft", fzf.filetypes)

vim.keymap.set("n", "<Space>fv", function()
	fzf.files({
		cwd = vim.g.vimfiles_path,
		previewer = false,
	})
end)

-- see: https://zenn.dev/uga_rosa/articles/318bba82c53a1d
vim.keymap.set("n", "<Space>fm", function(fzf_cb)
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 then
		print("Not in a git repository")
		return
	end

	fzf.fzf_exec(function(cb)
		for _, path in ipairs(vim.fn["mr#mru#list"]()) do
			local entry = fzf.make_entry.file(path, {
				cwd_only = true,
				file_icons = true,
				color_icons = true,
				cwd = git_root,
			})
			cb(entry)
		end
		-- 引数なしで呼び出すと、終わりとして処理される
		cb()
	end, {
		prompt = "> ",
		actions = {
			["default"] = fzf.actions.file_edit,
		},
		previewer = false,
		-- 相対パスになる
		-- cwd = git_root,
	})
end)

vim.keymap.set("n", "<Space>ff", function()
	vim.cmd("FzfLua git_files")
end)

vim.keymap.set("n", "<Space>rf", require("refactoring").select_refactor)

vim.keymap.set("n", "<Space>ft", fzf.filetypes)

vim.keymap.set("n", "<Space>fv", function()
	fzf.files({
		cwd = vim.g.vimfiles_path,
		previewer = false,
	})
end)

-- see: https://zenn.dev/uga_rosa/articles/318bba82c53a1d
vim.keymap.set("n", "<Space>fm", function(fzf_cb)
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 then
		print("Not in a git repository")
		return
	end

	fzf.fzf_exec(function(cb)
		for _, path in ipairs(vim.fn["mr#mru#list"]()) do
			local entry = fzf.make_entry.file(path, {
				cwd_only = true,
				file_icons = true,
				color_icons = true,
				cwd = git_root,
			})
			cb(entry)
		end
		-- 引数なしで呼び出すと、終わりとして処理される
		cb()
	end, {
		prompt = "> ",
		actions = {
			["default"] = fzf.actions.file_edit,
		},
		previewer = false,
		-- 相対パスになる
		-- cwd = git_root,
	})
end)
