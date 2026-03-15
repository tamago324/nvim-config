if vim.api.nvim_call_function("FindPlugin", { "trouble.nvim" }) == 0 then
	do
		return
	end
end

require('trouble').setup()
