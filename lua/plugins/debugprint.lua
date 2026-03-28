if vim.api.nvim_call_function("FindPlugin", { "debugprint.nvim" }) == 0 then
	do
		return
	end
end
