if vim.api.nvim_call_function("FindPlugin", { "nvim-scrollbar" }) == 0 then
	do
		return
	end
end

require("scrollbar").setup({
	show = true,
	handle = {
		text = "",
		color = "Normal",
	},
	marks = {
		-- Search = { text = { "-", "▬" }, priority = 0, color = "orange" },
		Error = { text = { "▬", "▬" }, priority = 1, highlight = "ScrollbarMarkError" },
		Warn = { text = { "▬", "▬" }, priority = 2, highlight = "ScrollbarMarkWarn" },
		Info = { text = { "▬", "▬" }, priority = 3, highlight = "ScrollbarMarkInfo" },
		Hint = { text = { "▬", "▬" }, priority = 4, highlight = "ScrollbarMarkHint" },
		Misc = { text = { "▬", "▬" }, priority = 5, highlight = "ScrollbarMarkMisc" },
		DocumentHighlight = { text = { "▬", "▬" }, priority = 6, highlight = "Yellow" },
	},
	excluded_filetypes = {
		"",
		"prompt",
		"TelescopePrompt",
	},
	autocmd = {
		render = {
			"BufWinEnter",
			"TabEnter",
			"TermEnter",
			"WinEnter",
			"CmdwinLeave",
			"TextChanged",
			"VimResized",
			"WinScrolled",
		},
	},
	handlers = {
		diagnostic = true,
		search = false,
	},
})

-- -- こんな感じで表示できる
-- require("scrollbar.handlers").register("my_marks", function(bufnr)
--     return {
--         { line = 2, type = "DocumentHighlight" }
--     }
-- end)
