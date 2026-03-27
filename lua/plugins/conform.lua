if vim.api.nvim_call_function("FindPlugin", { "conform.nvim" }) == 0 then
  do
    return
  end
end

require("conform").setup({
  formatters_by_ft = {
    -- cargo install stylua
    lua = { "stylua" },
    -- lsp/ruff.lua もみてね
    python = { "ruff_format", "ruff_fix" },
    typescriptreact = { "prettierd", "eslint_d" },
    typescript = { "prettierd", "eslint_d" }
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})
