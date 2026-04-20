if vim.api.nvim_call_function("FindPlugin", { "snacks.nvim" }) == 0 then
	do
		return
	end
end

local lir_float = require("lir.float")
local xpreview = require("xlir.float_preview")

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
				["<C-e>"] = function(self)
					local channel = vim.bo[self.buf].channel
					local pid = vim.fn.jobpid(channel)
					local cwd = vim.loop.fs_readlink("/proc/" .. pid .. "/cwd")
					lir_float.init(cwd)
					xpreview.on()
				end,
				term_normal = {
					"<A-o>",
					function()
						vim.cmd("stopinsert")
						Snacks.terminal.toggle()
					end,
					mode = "t",
				},
				term_normal_open = {
					"<A-S-o>",
					function()
						vim.cmd("stopinsert")
						Snacks.terminal.toggle(nil, {
							count = 2,
							win = {
								position = "float",
								border = "rounded",
							},
						})
					end,
					mode = "t",
				},
				term_normal2 = {
					"<esc>",
					function(self)
						self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
						if self.esc_timer:is_active() then
							self.esc_timer:stop()
							vim.cmd("stopinsert")
						else
							self.esc_timer:start(200, 0, function() end)
							return "<esc>"
						end
					end,
					mode = "t",
					expr = true,
					desc = "Double escape to normal mode",
				},
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
vim.keymap.set("n", "<A-o>", function()
	Snacks.terminal.toggle()
end, { desc = "terminal" })

-- terminal
vim.keymap.set("n", "<A-S-o>", function()
	Snacks.terminal.toggle(nil, {
		count = 2,
		win = {
			position = "float",
			border = "rounded",
		},
	})
end, { desc = "terminal" })
