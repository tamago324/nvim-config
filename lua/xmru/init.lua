local M = {}

local filename = vim.fn.expand(vim.g["mr#mru#filename"])
local Path = require("plenary.path")

M.list = function()
	return Path:new(filename):readlines()
end

return M

