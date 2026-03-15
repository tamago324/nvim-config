if vim.api.nvim_call_function("FindPlugin", { "pounce.nvim" }) == 0 then
	do
		return
	end
end

require'pounce'.setup{
  accept_keys = "OJFKDLSAHGNUVRBYTMICEXWPQZ",
  accept_best_key = "<enter>",
  multi_window = false,
  debug = false,
}

vim.api.nvim_set_keymap("n", "<CR>", "<Cmd>Pounce<CR>", { silent = true })
vim.api.nvim_set_keymap("x", "<CR>", "<Cmd>Pounce<CR>", { silent = true })
