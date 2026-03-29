if vim.api.nvim_call_function("FindPlugin", { "lazydev.nvim" }) == 0 then
	do
		return
	end
end

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})
