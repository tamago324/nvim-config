if vim.api.nvim_call_function("FindPlugin", { "hurl.nvim" }) == 0 then
	do
		return
	end
end

require("hurl").setup()

vim.api.nvim_create_augroup("user-hurl", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "user-hurl",
	pattern = "hurl",
	callback = function(args)
		local bufnr = args.buf
		vim.keymap.set("n", "<Space>rA", "<cmd>HurlRunner<CR>", { buffer = bufnr, desc = "Run All requests" })
		vim.keymap.set("n", "<Space>ra", "<cmd>HurlRunnerAt<CR>", { buffer = bufnr, desc = "Run Api request" })
		vim.keymap.set(
			"n",
			"<Space>rr",
			"<cmd>HurlRunnerToEntry<CR>",
			{ buffer = bufnr, desc = "Run Api request to entry" }
		)
		vim.keymap.set(
			"n",
			"<Space>rg",
			"<cmd>HurlRunnerToEnd<CR>",
			{ buffer = bufnr, desc = "Run Api request from current entry to end" }
		)
		vim.keymap.set("n", "<Space>rm", "<cmd>HurlToggleMode<CR>", { buffer = bufnr, desc = "Hurl Toggle Mode" })
		vim.keymap.set("n", "<Space>rv", "<cmd>HurlVerbose<CR>", { buffer = bufnr, desc = "Run Api in verbose mode" })
		vim.keymap.set(
			"n",
			"<Space>rV",
			"<cmd>HurlVeryVerbose<CR>",
			{ buffer = bufnr, desc = "Run Api in very verbose mode" }
		)
	end,
})
