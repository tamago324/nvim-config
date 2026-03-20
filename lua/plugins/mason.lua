if vim.api.nvim_call_function("FindPlugin", { "mason.nvim" }) == 0 or
  vim.api.nvim_call_function("FindPlugin", { "mason-lspconfig.nvim" }) == 0 then
	do
		return
	end
end

require('mason').setup({})

-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'jsonls',
    'ts_ls',
    'pyright'
  }
})
