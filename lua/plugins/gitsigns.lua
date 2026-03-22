if vim.api.nvim_call_function("FindPlugin", { "gitsigns.nvim" }) == 0 then
	do
		return
	end
end

-- http://www.shurey.com/js/works/unicode.html

local gitsigns = require("gitsigns")

gitsigns.setup({
	current_line_blame = true, -- これを有効にする
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' で行末に表示
		delay = 500, -- カーソルを止めてから表示されるまでのミリ秒
	},
})

vim.keymap.set("n", "<Space>gj", function()
	gitsigns.nav_hunk("next", { target = "unstaged", wrap = false })
end)
vim.keymap.set("n", "<Space>gk", function()
	gitsigns.nav_hunk("prev", { target = "unstaged", wrap = false })
end)

-- vim.keymap.set({ "n", "x" }, "<Space>gh", function()
-- 	local start_row = vim.fn.line("'<")
-- 	local end_row = vim.fn.line("'>")
-- 	gitsigns.stage_hunk({ start_row, end_row })
-- end)

vim.keymap.set({ "n" }, "<Space>gh", "<Cmd>Gitsigns stage_hunk<CR>")
vim.keymap.set({ "n" }, "<Space>gp", "<Cmd>Gitsigns preview_hunk_inline<CR>")
