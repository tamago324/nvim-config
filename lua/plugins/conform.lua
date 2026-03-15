if vim.api.nvim_call_function("FindPlugin", { "confirm.nvim" }) == 0 then
	do
		return
	end
end

require('conform').setup({
  formatters_by_ft = {
    -- cargo install stylua
    lua = {'stylua'}
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback"
  }
})
