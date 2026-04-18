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

vim.keymap.set("n", "gj", function()
	gitsigns.nav_hunk("next", { target = "unstaged", wrap = false })
end, { desc = "Gitsigns: next hunk" })
vim.keymap.set("n", "gk", function()
	gitsigns.nav_hunk("prev", { target = "unstaged", wrap = false })
end, { desc = "Gitsigns: prev hunk" })

-- vim.keymap.set({ "n", "x" }, "<Space>gh", function()
-- 	local start_row = vim.fn.line("'<")
-- 	local end_row = vim.fn.line("'>")
-- 	gitsigns.stage_hunk({ start_row, end_row })
-- end)

vim.keymap.set({ "n" }, "gsh", "<Cmd>Gitsigns stage_hunk<CR>", { desc = "Gitsigns: stage hunk" })
vim.keymap.set({ "n" }, "gsr", "<Cmd>Gitsigns reset_hunk<CR>", { desc = "Gitsigns: reset hunk" })
vim.keymap.set({ "n" }, "gsp", "<Cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Gitsigns: preview hunk" })
vim.keymap.set({ "n" }, "gsb", "<Cmd>Gitsigns blame<CR>", { desc = "Gitsigns: blame" })

-- origin/HEAD との全量比較
vim.keymap.set("n", "gdt", function()
	gitsigns.diffthis("origin/HEAD")
end, { desc = "diffthis origin/HEAD" })

vim.keymap.set("n", "gdo", "diffoff", { desc = "diffoff" })

-- 比較対象を origin/HEAD に切り替える
vim.keymap.set("n", "gdh", function()
	gitsigns.change_base("origin/HEAD", true)
end, { desc = "preview origin/HEAD" })

vim.keymap.set("n", "gdj", function()
	vim.ui.input({
		prompt = "BranchName: ",
		default = "origin/HEAD",
	}, function(branch)
		gitsigns.change_base(branch, true)
	end)
end, { desc = "preview origin/HEAD" })

-- 比較対象をデフォルト(index)に戻す
vim.keymap.set({ "n" }, "gdr", "<Cmd>Gitsigns reset_base<CR>", { desc = "Gitsigns: reset base" })
