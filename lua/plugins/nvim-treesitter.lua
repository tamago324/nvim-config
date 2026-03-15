if vim.api.nvim_call_function("FindPlugin", { "nvim-treesitter" }) == 0 then
	do
		return
	end
end

-- https://blog.atusy.net/2025/08/10/nvim-treesitter-main-branch/

-- いれておく
-- sudo apt update
-- sudo apt install -y clang libclang-dev
-- cargo install --locked tree-sitter-cli

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
  callback = function()
    -- 必要に応じて`ctx.match`に入っているファイルタイプの値に応じて挙動を制御
    -- `pcall`でエラーを無視することでパーサーやクエリがあるか気にしなくてすむ

    -- 構文ハイライト
    pcall(vim.treesitter.start)

    -- インデント
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require('nvim-treesitter').install({
  'python', 'typescript', 'vim', 'json', 'lua', 'javascript', 'html', 'markdown', 'tsx'
})

