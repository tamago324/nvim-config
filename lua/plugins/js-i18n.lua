if vim.api.nvim_call_function("FindPlugin", { "js-i18n.nvim" }) == 0 then
	do
		return
	end
end

require("js-i18n").setup({
	server = {
		cmd = { "pnpm", "dlx", "js-i18n-language-server" },
		primary_languages = { "ja" },
	},
})
