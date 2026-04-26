local palette = require("catppuccin.palettes").get_palette()

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number,line"

-- vim.api.nvim_set_hl(0, "MntCursorLine", {
-- 	bg = palette.surface1,
-- })

vim.api.nvim_set_hl(0, "MntCursorLineNr", {
	fg = palette.yellow,
	bold = true,
})

local function set_project_winhighlight()
	local path = vim.api.nvim_buf_get_name(0)

	if path:match("/mnt/") then
		vim.wo.winhighlight = table.concat({
			-- "CursorLine:MntCursorLine",
			"CursorLineNr:MntCursorLineNr",
		}, ",")
		vim.wo.number = true
	else
		vim.wo.winhighlight = ""
		vim.wo.number = false
	end
end

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	callback = set_project_winhighlight,
})
