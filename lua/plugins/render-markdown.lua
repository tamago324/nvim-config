if vim.api.nvim_call_function("FindPlugin", { "render-markdown.nvim" }) == 0 then
	do
		return
	end
end

require("render-markdown").setup({
	file_types = { "AgenticChat" },
})
