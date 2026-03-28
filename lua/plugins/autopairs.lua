if vim.api.nvim_call_function("FindPlugin", { "nvim-autopairs" }) == 0 then
	do
		return
	end
end

require("nvim-autopairs").setup({})
