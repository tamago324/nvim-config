local Input = require("nui.input")

local M = {}

M.highlights = {
	red = "ErrorFloat",
	blue = "InfoFloat",
	green = "HintFloat",
	yellow = "WarningFloat",
}

function M.input(opts)
	vim.validate({
		title = { opts.title, "string", false },
		on_submit = { opts.on_submit, "function", false },
		on_change = { opts.on_change, "function", true },
		prompt = { opts.prompt, "string", true },
		border_color = { opts.border_color, "string", true },
		default_value = { opts.default_value, "string", true },
	})

	local prompt = vim.F.if_nil(opts.prompt, "> ")
	local border_highlight = M.highlights[vim.F.if_nil(opts.border_color, "yellow")] or M.highlights["yellow"]
	local default_value = vim.F.if_nil(opts.default_value, "")

	local popup_options = {
		relative = "cursor",
		position = {
			row = 0,
			col = 2,
		},
		size = 50,
		border = {
			style = { "+", "─", "+", "│", "+", "─", "+", "│" },
			highlight = border_highlight,
			text = {
				top = "[" .. opts.title .. "]",
				top_align = "left",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal",
		},
		zindex = 500,
	}

	local i = Input(popup_options, {
		prompt = prompt,
		-- on_submit = function(value)
		--   callback(value)
		-- end
		on_submit = opts.on_submit,
		on_change = opts.on_change,
		default_value = default_value,
	})

	i:mount()

	-- mappings
	vim.api.nvim_buf_set_keymap(0, "i", "<Esc>", "<C-c>", { noremap = true })
	vim.api.nvim_buf_set_keymap(0, "i", "<C-w>", "<C-S-W>", { noremap = true })
end

return M
