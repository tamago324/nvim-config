if vim.api.nvim_call_function("FindPlugin", { "autoclose.nvim" }) == 0 then
	do
		return
	end
end

require("autoclose").setup()
