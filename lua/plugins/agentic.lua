if vim.api.nvim_call_function("FindPlugin", { "agentic.nvim" }) == 0 then
	do
		return
	end
end

-- https://github.com/carlos-algms/agentic.nvim

local agentic = require("agentic")

agentic.setup({
	-- codex-acp: npm i -g @zed-industries/codex-acp
	-- provider = "codex-acp",

	-- npm i -g pi-acp
	provider = "pi-acp",
})

vim.keymap.set({ "n", "v", "i" }, "<A-i>", agentic.toggle)
vim.keymap.set({ "n", "x" }, "<A-x>", agentic.add_selection_or_file_to_context)
vim.keymap.set({ "n", "v", "i" }, "<A-,>", agentic.new_session)
vim.keymap.set({ "n", "v", "i" }, "<A-d>", agentic.add_current_line_diagnostics)

-- keys = {
--   {
--     "<C-\\>",
--     function() require("agentic").toggle() end,
--     mode = { "n", "v", "i" },
--     desc = "Toggle Agentic Chat"
--   },
--   {
--     "<C-'>",
--     function() require("agentic").add_selection_or_file_to_context() end,
--     mode = { "n", "v" },
--     desc = "Add file or selection to Agentic to Context"
--   },
--   {
--     "<C-,>",
--     function() require("agentic").new_session() end,
--     mode = { "n", "v", "i" },
--     desc = "New Agentic Session"
--   },
--   {
--     "<A-i>r", -- ai Restore
--     function()
--         require("agentic").restore_session()
--     end,
--     desc = "Agentic Restore session",
--     silent = true,
--     mode = { "n", "v", "i" },
--   },
--   {
--     "<leader>ad", -- ai Diagnostics
--     function()
--         require("agentic").add_current_line_diagnostics()
--     end,
--     desc = "Add current line diagnostic to Agentic",
--     mode = { "n" },
--   },
--   {
--     "<leader>aD", -- ai all Diagnostics
--     function()
--         require("agentic").add_buffer_diagnostics()
--     end,
--     desc = "Add all buffer diagnostics to Agentic",
--     mode = { "n" },
--   },
-- },
