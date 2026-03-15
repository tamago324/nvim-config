if vim.api.nvim_call_function("FindPlugin", { "tiny-inline-diagnostic.nvim" }) == 0 then
	do
		return
	end
end


require("tiny-inline-diagnostic").setup({
  options = {
    multilines = {
      enabled = true,
    },
    -- カーソル行すべてのものを表示
    show_all_diags_on_cursorline = true,
  },
})
vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
