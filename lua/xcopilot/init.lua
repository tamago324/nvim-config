local M = {}

local a = vim.api

local state = {}
state.buf = nil
state.win = nil

M.hide = function()
	if a.nvim_win_is_valid(state.win) then
		a.nvim_win_hide(state.win)
	end
end

local copilot_pane = function()
	local _pane_id = vim.fn.system(
		"wezterm.exe cli list --format json | jq 'map(select(.tab_id == 0)) | sort_by(.top_row, .left_col) | .[0].pane_id'"
	)
	return vim.fn.substitute(_pane_id, "[\r\n]\\+$", "", "")
end

-- 文字列を左上のパネルに送る
M.send_text = function(text)
	vim.fn.system("wezterm.exe cli send-text --pane-id " .. copilot_pane() .. " " .. vim.fn.shellescape(text))
end

-- Ctrl+C を送る
M.send_ctrl_c = function()
	vim.fn.system("wezterm.exe cli send-text --pane-id " .. copilot_pane() .. " --no-paste $'\x03'")
end

-- co_editor にテキストを送る
M.put_co_editor = function(text_lines)
	a.nvim_buf_set_lines(state.buf, -1, -1, false, text_lines)
end

M.open = function()
	if state.buf == nil then
		state.buf = a.nvim_create_buf(false, true)
	end

	local ui = a.nvim_list_uis()[1]
	local float_height = 15

	state.win = a.nvim_open_win(state.buf, true, {
		relative = "editor",
		width = ui.width,
		height = float_height,
		row = ui.height - float_height,
		col = 0,
		focusable = true,
		style = "minimal",
		border = "single",
	})

	vim.keymap.set("n", "q", M.hide, { noremap = true, silent = true })
	vim.keymap.set({ "i", "n" }, "<C-c>", M.send_ctrl_c, { noremap = true, silent = true })

	vim.api.nvim_create_autocmd({ "WinLeave" }, {
		buffer = state.buf,
		callback = M.hide,
	})
end

return M
