if vim.api.nvim_call_function("FindPlugin", { "hurl.nvim" }) == 0 then
	do
		return
	end
end

require("hurl").setup({})
