scriptencoding utf-8
UsePlugin 'vim-gindent'

let g:gindent = {}
let g:gindent.enabled = { -> index(['php', 'yaml', 'graphql', 'typescriptreact', 'jsx'], &filetype) != -1 }

" call gindent#register_preset('php', {
"\ 'indent_pattern'
"\ })
