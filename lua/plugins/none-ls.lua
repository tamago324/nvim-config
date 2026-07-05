if vim.api.nvim_call_function("FindPlugin", { "none-ls.nvim" }) == 0 then
	do
		return
	end
end

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.textlint.with({
			filetypes = { "markdown" },
		}),
		null_ls.builtins.code_actions.textlint.with({
			filetypes = { "markdown" },
		}),
		null_ls.builtins.formatting.textlint.with({
			filetypes = { "markdown" },
		}),
	},
})
