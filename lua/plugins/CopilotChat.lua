if vim.api.nvim_call_function("FindPlugin", { "CopilotChat.nvim" }) == 0 then
	do
		return
	end
end

local copilot = require("CopilotChat")
copilot.setup({
	highlight_headers = false,
	separator = "---",
	error_header = "> [!ERROR] Error",
})

vim.keymap.set({ "n", "x" }, "<A-i>", function()
	local float_height = 30

	copilot.toggle({
		auto_insert_mode = false,
		window = {
			layout = "float",
			relative = "editor",
			width = 1,
			height = float_height,
			row = vim.o.lines - float_height,
			col = 0,
			border = "single",
			blend = 5,
		},
	})
end)

require("render-markdown").setup({
	file_types = { "copilot-chat" },
})
