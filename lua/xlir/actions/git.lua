local M = {}

local lir = require("lir")
local actions = require("lir.actions")

local function is_staged(file)
	local result = vim.fn.systemlist({ "git", "diff", "--cached", "--name-only", "--", file })
	return #result > 0
end

-- ステージのトグル
M.stage_toggle = function()
	local ctx = lir.get_context():current()
	if ctx.is_dir then
		-- ディレクトリは対象外にする
		return
	end
	local fullpath = vim.fn.fnameescape(ctx.fullpath)

	local lnum = vim.fn.line(".")

	if is_staged(fullpath) then
		vim.cmd("Git restore --staged " .. fullpath)
	else
		vim.cmd("Git add " .. fullpath)
	end
	actions.reload()

	vim.cmd("" .. lnum)
end

return M
