if vim.api.nvim_call_function("FindPlugin", { "fzf-lua" }) == 0 then
	do
		return
	end
end

require("fzf-lua").setup({})

vim.keymap.set("n", "<Space>fo", function()
	vim.cmd("FzfLua lsp_workspace_symbols")
end)
