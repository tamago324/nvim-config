if vim.api.nvim_call_function("FindPlugin", { "pretty_hover" }) == 0 then
	do
		return
	end
end

require("pretty_hover").setup({})
