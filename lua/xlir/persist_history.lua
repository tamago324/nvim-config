local history = require("lir.history")
local Path = require("plenary.path")

local M = {}

local cache_file_path = Path:new(vim.fn.stdpath("cache"), "lir", "history")

M.save = function()
  local dir = cache_file_path:parent()
  if not dir:exists() then
    dir:mkdir({ parents = true })
  end
  cache_file_path:write(vim.mpack.encode(history.get_all()), "w")
end

local restore = function()
  if cache_file_path:exists() then
    local ok, histories = pcall(vim.mpack.decode, cache_file_path:read())
    if ok then
      history.replace_all(histories)
    end
  end
end

M.setup = function()
  restore()

  -- Save when exiting Vim
  vim.api.nvim_exec(
    [[
augroup my-lir-persistent
  autocmd!
  autocmd ExitPre * lua require('xlir.persist_history').save()
augroup END
  ]],
    false
  )
end

return M
