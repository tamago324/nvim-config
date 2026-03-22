if vim.api.nvim_call_function("FindPlugin", { "ccc.nvim" }) == 0 then
	do
		return
	end
end

local ccc = require("ccc")

ccc.setup({
	highlighter = {
		auto_enable = true,
		lsp = true,
	},
})
