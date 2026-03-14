local lir = require("lir")
local actions = require("lir.actions")

return function()
	local ctx = lir.get_context()
	actions.cd()
	vim.fn["deol#cd"](ctx.dir)
end
