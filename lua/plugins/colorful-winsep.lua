if vim.api.nvim_call_function("FindPlugin", { "colorful-winsep.nvim" }) == 0 then
	do
		return
	end
end

require("colorful-winsep").setup()
