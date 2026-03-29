if vim.api.nvim_call_function("FindPlugin", { "spring-initializr.nvim" }) == 0 then
	do
		return
	end
end

require("spring-initializr").setup()
