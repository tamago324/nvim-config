if vim.api.nvim_call_function("FindPlugin", { "neogit" }) == 0 then
	do
		return
	end
end

local neogit = require("neogit")

neogit.setup({})
