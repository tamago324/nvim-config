local lir = require("lir")
local actions = require("lir.actions")

-- deol が表示されているか
local is_show_deol = function()
	if vim.fn.exists("t:deol") ~= 1 then
		return false
	end

	return not vim.tbl_isempty(vim.fn.win_findbuf(vim.t.deol.bufnr))
end

local open_deol = function()
	local ctx = lir.get_context()
	actions.quit()
	-- if vim.fn.exists('t:deol') ~= 1 then
	--   -- 存在していない場合、deol_terminal() を開く
	--   require"plugins/telescope/deol_terminal"(ctx.dir)
	--   return
	-- end
	if not is_show_deol() then
		vim.fn.DeolOpen()
	end
	vim.fn["deol#cd"](ctx.dir)
end

return open_deol
