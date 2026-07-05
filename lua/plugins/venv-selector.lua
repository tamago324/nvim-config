if vim.api.nvim_call_function("FindPlugin", { "venv-selector.nvim" }) == 0 then
	do
		return
	end
end

require("venv-selector").setup()
