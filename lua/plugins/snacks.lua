if vim.api.nvim_call_function("FindPlugin", { "snacks.nvim" }) == 0 then
	do
		return
	end
end

require("snacks").setup({
	bigfile = { enabled = false },
	dashboard = { enabled = false },
	explorer = { enabled = false },
	indent = { enabled = false },
	input = { enabled = false },
	picker = {
		enabled = true,
		sources = {
			commands = {
				layout = { preset = "vscode" },
				preview = "none",
			},
		},
	},
	notifier = { enabled = false },
	quickfile = { enabled = false },
	scope = { enabled = false },
	scroll = { enabled = false },
	statuscolumn = { enabled = false },
	words = { enabled = false },
	styles = {
		terminal = {
			keys = {
				["<Tab>"] = "hide",
			},
		},
	},
})

vim.keymap.set("n", "<Space>dg", function()
	Snacks.lazygit()
end, { desc = "lazygit" })

vim.keymap.set("n", ",w", function()
	Snacks.picker.files()
end, { desc = "files" })

vim.keymap.set("n", ",s", function()
	Snacks.picker.smart()
end, { desc = "files" })

vim.keymap.set("n", ",g", function()
	Snacks.picker.command_history()
end, { desc = "command history" })

vim.keymap.set("n", "<Space>fh", function()
	Snacks.picker.help()
end, { desc = "help" })

vim.keymap.set("n", "<Space><CR>", function()
	Snacks.picker.commands()
end, { desc = "command history" })

-- terminal
vim.keymap.set("n", "<A-d>", function()
	Snacks.terminal.toggle()
end, { desc = "terminal" })
