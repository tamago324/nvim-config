if vim.api.nvim_call_function("FindPlugin", { "tailwind-fold.nvim" }) == 0 then
	do
		return
	end
end

require("tailwind-fold").setup({
	ft = { "typescriptreact" },
})
