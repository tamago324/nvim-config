local M = {}

local Path = require("plenary.path")
local confirm = require("xlir.nui.confirm").confirm

local a = vim.api
local uv = vim.uv or vim.loop

local BACKUP_INTERVAL_MS = 5000
local BACKUP_DIR = Path:new(vim.fn.expand("~/.cache"), "xcopilot")

local function ensure_buf(state)
  if state.buf == nil or not a.nvim_buf_is_valid(state.buf) then
    state.buf = a.nvim_create_buf(false, true)
  end
end

local function current_lines(state)
  if state.buf == nil or not a.nvim_buf_is_valid(state.buf) then
    return {}
  end

  local lines = a.nvim_buf_get_lines(state.buf, 0, -1, false)
  if #lines == 1 and lines[1] == "" then
    return {}
  end

  return lines
end

local function current_git_root()
  local git_dir = vim.fs.find(".git", { path = vim.fn.getcwd(), upward = true })[1]
  if git_dir == nil or git_dir == "" then
    return nil
  end

  return vim.fs.dirname(git_dir)
end

local function backup_path_for(git_root)
  if git_root == nil or git_root == "" then
    return nil
  end

  return Path:new(BACKUP_DIR:absolute(), "buffer-" .. vim.fn.sha256(git_root))
end

local function delete_backup(backup_path)
  if backup_path == nil or not backup_path:exists() then
    return
  end

  uv.fs_unlink(backup_path:absolute())
end

local function save_backup(state)
  if state.backup_path == nil then
    return
  end

  local lines = current_lines(state)
  if #lines == 0 then
    delete_backup(state.backup_path)
    return
  end

  if not BACKUP_DIR:exists() then
    BACKUP_DIR:mkdir({ parents = true })
  end

  state.backup_path:write(table.concat(lines, "\n"), "w")
end

local function restore_backup(state, backup_path)
  if backup_path == nil or not backup_path:exists() then
    return
  end

  local text = backup_path:read()
  local lines = text == "" and {} or vim.split(text, "\n", { plain = true })
  a.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
end

local function maybe_restore_backup(state)
  if state.backup_path == nil or not state.backup_path:exists() then
    return
  end

  if #current_lines(state) ~= 0 then
    return
  end

  confirm({
    title = "Restore xcopilot backup?",
    yes = function()
      restore_backup(state, state.backup_path)
    end,
  })
end

function M.setup(state)
  if state.timer == nil then
    state.timer = assert(uv.new_timer())
    state.timer:start(
      BACKUP_INTERVAL_MS,
      BACKUP_INTERVAL_MS,
      vim.schedule_wrap(function()
        save_backup(state)
      end)
    )
  end

  if state.autocmd_group == nil then
    state.autocmd_group = a.nvim_create_augroup("xcopilot-backup", { clear = true })
    a.nvim_create_autocmd("ExitPre", {
      group = state.autocmd_group,
      callback = function()
        save_backup(state)
      end,
    })
  end
end

function M.sync_project(state)
  ensure_buf(state)

  local git_root = current_git_root()
  local project_key = git_root
  local backup_path = backup_path_for(git_root)
  if state.project_key == project_key then
    state.backup_path = backup_path
    return
  end

  save_backup(state)

  state.project_key = project_key
  state.backup_path = backup_path
  a.nvim_buf_set_lines(state.buf, 0, -1, false, {})
end

function M.save(state)
  save_backup(state)
end

function M.restore_if_needed(state)
  maybe_restore_backup(state)
end

return M
