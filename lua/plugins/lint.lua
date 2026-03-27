if vim.api.nvim_call_function("FindPlugin", { "nvim-lint" }) == 0 then
  do
    return
  end
end

local lint = require('lint')
lint.linters_by_ft = {
  typescriptreact = { 'eslint_d' },
  typescript = { 'eslint_d' },
}


vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  callback = function()
    lint.try_lint(nil, { ignore_errors = true })
  end,
})
