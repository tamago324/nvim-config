local lir = require("lir")
local utils = lir.utils
local actions = require("lir.actions")

local function rename_and_jump()
	local ctx = lir.get_context()
	local old = string.gsub(ctx:current_value(), "/$", "")
	local new = vim.fn.input("Rename: ", old)
	if new == "" or new == old then
		return
	end

	if new == "." or new == ".." or string.match(new, "[/\\]") then
		utils.error("Invalid name: " .. new)
		return
	end

	if not vim.loop.fs_rename(ctx.dir .. old, ctx.dir .. new) then
		utils.error("Rename failed")
	end

	actions.reload()

	local lnum = lir.get_context():indexof(new)
	if lnum then
		vim.cmd(tostring(lnum))
	end
end

return rename_and_jump
