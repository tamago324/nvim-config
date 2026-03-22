-- 保存時に自動でインポートの順序を修正
-- https://github.com/astral-sh/ruff-lsp/issues/387#issuecomment-2071912810
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.py" },
	callback = function()
		vim.lsp.buf.code_action({
			context = {
				only = { "source.organizeImports.ruff" },
			},
			apply = true,
		})
		-- vim.lsp.buf.format({
		-- 	async = true,
		-- 	filter = function(client)
		-- 		return client.name ~= "typescript-tools"
		-- 	end,
		-- })
		vim.wait(100)
	end,
})

return {}
