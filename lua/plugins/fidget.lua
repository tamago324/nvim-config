if vim.api.nvim_call_function("FindPlugin", { "fidget.nvim" }) == 0 then
	do
		return
	end
end

require("fidget").setup({
	sources = {
		["null-ls"] = {
			ignore = true,
		},
	},
})
