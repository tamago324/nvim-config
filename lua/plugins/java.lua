if vim.api.nvim_call_function("FindPlugin", { "nvim-java" }) == 0 then
	do
		return
	end
end

require("java").setup({
	-- 時間がかかりすぎるため、いったんOFF
	spring_boot_tools = {
		enable = false,
		version = "1.55.1",
	},
})
vim.lsp.enable("jdtls")
