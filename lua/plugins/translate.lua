if vim.api.nvim_call_function("FindPlugin", { "translate.nvim" }) == 0 then
	do
		return
	end
end

require("translate").setup({
	-- default = {
	-- 	output = "floating",
	-- },
})

vim.keymap.set(
	{ "n", "x" },
	"[tr",
	"<Cmd>Translate ja<CR>",
	{ noremap = true, silent = true, desc = "Translate to Japanese" }
)
vim.keymap.set(
	{ "n", "x" },
	"]tr",
	"<Cmd>Translate en<CR>",
	{ noremap = true, silent = true, desc = "Translate to English" }
)
