if vim.api.nvim_call_function("FindPlugin", { "inc-rename.nvim" }) == 0 then
	do
		return
	end
end

require("inc_rename").setup()
