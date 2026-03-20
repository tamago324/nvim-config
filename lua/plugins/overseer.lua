if vim.api.nvim_call_function("FindPlugin", { "overseer.nvim" }) == 0 then
	do
		return
	end
end

require('overseer').setup()

