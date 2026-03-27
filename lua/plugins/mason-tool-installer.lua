if
    vim.api.nvim_call_function("FindPlugin", { "mason-tool-installer.nvim" }) == 0
then
  do
    return
  end
end

require('mason-tool-installer').setup {
  ensure_installed = {
    "eslint_d",
    -- "ruff",
    "prettierd"
  }
}
