if vim.api.nvim_call_function("FindPlugin", { "numb.nvim" }) == 0 then
	do
		return
	end
end

require('numb').setup()
