if vim.api.nvim_call_function("FindPlugin", { "nvim-colorizer.lua" }) == 0 then
	do
		return
	end
end

require("colorizer").setup({})
