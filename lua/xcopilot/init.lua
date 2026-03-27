local M = {}

local backup = require("xcopilot.backup")
local confirm = require("xlir.nui.confirm").confirm

local a = vim.api

local state = {}
state.buf = nil
state.win = nil

M.hide = function()
  if state.win ~= nil and a.nvim_win_is_valid(state.win) then
    a.nvim_win_hide(state.win)
  end
end

local copilot_pane = function()
  local _pane_id = vim.fn.system("wezterm.exe cli get-pane-direction Next")
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

-- Enter キーのみを送信する関数
M.send_enter = function()
  vim.fn.system("wezterm.exe cli send-text --pane-id " .. copilot_pane() .. " --no-paste $'\x0d'")
end

-- co_editor にテキストを送る
M.put_co_editor = function(text_lines)
  a.nvim_buf_set_lines(state.buf, -1, -1, false, text_lines)
end

-- co_editor から Copilot にテキストを送る
M.send_copilot_editor_text = function()
  local text = table.concat(a.nvim_buf_get_lines(state.buf, 0, -1, false), "\n")
  if text == "" then
    return
  end

  confirm({
    title = "Send Copilot?",
    yes = function()
      M.send_text(text)
      a.nvim_buf_set_lines(state.buf, 0, -1, false, {})
      backup.save(state)
      M.send_enter()
    end,
  })
end

---@return number|nil
local function find_co_editor()
  for _, win in ipairs(a.nvim_tabpage_list_wins(0)) do
    local buf = a.nvim_win_get_buf(win)
    if buf == state.buf then
      return win
    end
  end
  return nil
end

M.open = function()
  backup.sync_project(state)

  local co_editor_win = find_co_editor()
  if co_editor_win then
    a.nvim_set_current_win(co_editor_win)
    backup.restore_if_needed(state)
    return
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

  a.nvim_win_set_option(state.win, 'winblend', 20)

  local opts = { noremap = true, silent = true, buffer = state.buf }

  vim.keymap.set("n", "q", M.hide, opts)
  vim.keymap.set("n", "<Esc>", M.hide, opts)
  vim.keymap.set("n", "<A-i>", M.hide, opts)
  vim.keymap.set({ "i", "n" }, "<C-c>", M.send_ctrl_c, opts)
  vim.keymap.set({ "n" }, "<CR>", M.send_copilot_editor_text, opts)

  backup.restore_if_needed(state)
end

vim.keymap.set("n", "<A-i>", M.open)

backup.setup(state)

return M
