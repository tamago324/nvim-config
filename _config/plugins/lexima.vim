UsePlugin 'lexima.vim'
scriptencoding utf-8


" https://github.com/yukiycino-dotfiles/dotfiles/blob/b8b12149c85fc7605af98320ae1289a6b8908aa9/.vimrc#L1178-L1328

" <Esc> をマッピングしないようにする
let g:lexima_map_escape = ''
" " endwise をしないようにする
" let g:lexima_enable_endwise_rules = 0
let g:lexima_enable_endwise_rules = 1

" TODO: オススメらしい？
let g:lexima_accept_pum_with_enter = 0

let s:rules = []


" 設定のリセット
call lexima#set_default_rules()


" \%# はカーソル位置


" ====================
" カッコ (Parenthesis)
" ====================
" 閉じ括弧も削除
call add(s:rules, { 'char': '<C-h>', 'at': '(\%#)',  'input': '<BS><Del>' })
call add(s:rules, { 'char': '<BS>',  'at': '(\%#)',  'input': '<BS><Del>' })
call add(s:rules, { 'char': '<C-w>', 'at': '(\%#)',  'input': '<BS><Del>' })


" ====================
" 波カッコ (Brace)
" ====================
" 閉じ括弧も削除
call add(s:rules, { 'char': '<C-h>', 'at': '{\%#}',  'input': '<BS><Del>' })
call add(s:rules, { 'char': '<BS>',  'at': '{\%#}',  'input': '<BS><Del>' })
call add(s:rules, { 'char': '<C-w>', 'at': '{\%#}',  'input': '<BS><Del>' })



" ====================
" 角カッコ (Bracket)
" ====================
" 閉じ括弧も削除
call add(s:rules, { 'char': '<C-h>', 'at': '\[\%#\]',  'input': '<BS><Del>' })
call add(s:rules, { 'char': '<BS>',  'at': '\[\%#\]',  'input': '<BS><Del>' })
call add(s:rules, { 'char': '<C-w>', 'at': '\[\%#\]',  'input': '<BS><Del>' })



" ====================
" シングルクオート (Single Quote)
" ====================
" 閉じクオートも削除
call add(s:rules, { 'char': '<C-h>', 'at': "'\\%#'",  'input': '<BS><Del>' })
call add(s:rules, { 'char': '<BS>',  'at': "'\\%#'",  'input': '<BS><Del>' })
call add(s:rules, { 'char': '<C-w>', 'at': "'\\%#'",  'input': '<BS><Del>' })


" ====================
" ダブルクオート (Double Quote)
" ====================
" 閉じクオートも削除
call add(s:rules, { 'char': '<C-h>', 'at': '"\%#"',  'input': '<BS><Del>' })
call add(s:rules, { 'char': '<BS>',  'at': '"\%#"',  'input': '<BS><Del>' })
call add(s:rules, { 'char': '<C-w>', 'at': '"\%#"',  'input': '<BS><Del>' })



" ====================
" バッククオート (Back Quote)
" ====================
" 閉じクオートも削除
call add(s:rules, { 'char': '<C-h>', 'at': '`\%#`',  'input': '<BS><Del>' })
call add(s:rules, { 'char': '<BS>',  'at': '`\%#`',  'input': '<BS><Del>' })
call add(s:rules, { 'char': '<C-w>', 'at': '`\%#`',  'input': '<BS><Del>' })



" ====================
" lua
" ====================
" call add(s:rules, { 'filetype': ['lua'], 'char': "'", 'at': 'require\%#',  'input': "''\<Left>" })
" call add(s:rules, { 'filetype': ['lua'], 'char': ">", 'at': '([^)]*\%#)',  'input': "function ()\nend\<Up>\<End>\<Left>" })


" ====================
" python
" ====================
call add(s:rules, { 'filetype': ['python'], 'char': "'", 'at': 'f\%#',  'input': "''\<Left>" })
call add(s:rules, { 'filetype': ['python'], 'char': "'", 'at': 'r\%#',  'input': "''\<Left>" })


" " ====================
" " vim
" " ====================
" call add(s:rules, { 'filetype': ['vim'], 'char': '<', 'at': '^\s*\(autocmd\|.[nore]map\)\s*',  'input': "<>\<Left>" })


" ====================
" telescope
" ====================
" call add(s:rules, { 'filetype': ['TelescopePrompt'], 'char': "'", 'input': "\<Del>" })
" /** と入力したら **/ を補完して間にカーソルを置く
call lexima#add_rule({
\   'char': ' ',
\   'at': '/\*\*\%#',
\   'input': ' **/<Left><Left><Left>',
\   'filetype': ['javascript', 'typescript', 'javascriptreact', 'typescriptreact']
\ })

" /** の直後に Enter を押した時の挙動
call lexima#add_rule({
\   'char': '<Enter>',
\   'at': '/\*\*\%#',
\   'input': '<Enter>* <Enter>*/<Up>',
\   'filetype': ['javascript', 'typescript', 'javascriptreact', 'typescriptreact']
\ })

" コメント行内で Enter を押した時に次の行にも * を付ける
call lexima#add_rule({
\   'char': '<Enter>',
\   'at': '^\s*\* \%#',
\   'input': '<Enter>* ',
\   'filetype': ['javascript', 'typescript', 'javascriptreact', 'typescriptreact']
\ })

" ====================
" rust
" ====================
call add(s:rules, { 'filetype': ['rust'], 'char': "'",                      'input': "''\<Left>"    })
call add(s:rules, { 'filetype': ['rust'], 'char': "'", 'at': 'b\%#',        'input': "''\<Left>" })
call add(s:rules, { 'filetype': ['rust'], 'char': "<", 'at': 'Vec\%#',      'input': "<>\<Left>" })
call add(s:rules, { 'filetype': ['rust'], 'char': "<", 'at': 'struct.*\%#', 'input': "<>\<Left>" })
call add(s:rules, { 'filetype': ['rust'], 'char': "<", 'at': '::\%#',       'input': "<>\<Left>" })
call add(s:rules, { 'filetype': ['rust'], 'char': "<", 'at': 'Box\%#',      'input': "<>\<Left>" })
call add(s:rules, { 'filetype': ['rust'], 'char': "<", 'at': 'Some\%#',     'input': "<>\<Left>" })
call add(s:rules, { 'filetype': ['rust'], 'char': ">", 'at': '<\%#',        'input': ">\<Left>" })



" ====================
" markdown
" ====================
" Thanks https://github.com/yukiycino-dotfiles/dotfiles/blob/1cdadb87170aa5b1f93bd06729442e420b9f13e6/.vimrc#L2049
call add(s:rules, { 'filetype': 'markdown', 'char': '<Space>', 'at': '^\s*\%#',         'input': "*<Space>"         })
call add(s:rules, { 'filetype': 'markdown', 'char': '<Space>', 'at': '^\s*\%#',         'input': "*<Space>"         })
call add(s:rules, { 'filetype': 'markdown', 'char': '<Space>', 'at': '^\s*\*\s\%#',     'input': "<Home><Tab><End>" })
call add(s:rules, { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*\%#',         'input': "*<Space>"         })
call add(s:rules, { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*\*\s\%#',     'input': "<Home><Tab><End>" })
call add(s:rules, { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*\*\s\w.*\%#', 'input': "<Home><Tab><End>" })
call add(s:rules, { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+\s\+\%#',    'input': "<C-d>"            })
call add(s:rules, { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+\*\s\+\%#',  'input': "<C-d>"            })
call add(s:rules, { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\*\s\+\%#',      'input': ""                 })
call add(s:rules, { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\%#',            'input': ""                 })
call add(s:rules, { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\* \%#',         'input': "<C-w>"            })
call add(s:rules, { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^\*\s\%#',        'input': "<C-w>"            })

" なぜか、二回 <CR> が必要
call add(s:rules, { 'filetype': 'markdown', 'char': '<CR>', 'at': '^\*\s\%#',     'input': "<C-u><C-u><CR><CR>" })
call add(s:rules, { 'filetype': 'markdown', 'char': '<CR>', 'at': '^\s\+\*\s\%#', 'input': "<C-u><C-u><CR>"     })

call add(s:rules, { 'filetype': ['java'], 'char': "*", 'at': '/\*\%#',        'input': "*  */\<Left>\<Left>\<Left>" })
call add(s:rules, { 'filetype': ['java'], 'char': ">", 'at': '<\%#',        'input': ">\<Left>" })


" " https://github.com/yuki-yano/dotfiles/blob/7c2eabca5e5a0ffe5632e64243d149e7f5b87503/.vimrc#L2755
" call add(s:rules, { 'filetype': ['typescript', 'javascript'], 'char': '>', 'at': '\s([a-zA-Z, ]*\%#)',            'input': '<Left><C-o>f)<Right>a=> {}<Esc>',  })
" call add(s:rules, { 'filetype': ['typescript', 'javascript'], 'char': '>', 'at': '\s([a-zA-Z]\+\%#)',             'input': '<Right> => {}<Left>',              'priority': 10  })
" call add(s:rules, { 'filetype': ['typescript', 'javascript'], 'char': '>', 'at': '[a-z]((.*\%#.*))',              'input': '<Left><C-o>f)a => {}<Esc>',  })
" call add(s:rules, { 'filetype': ['typescript', 'javascript'], 'char': '>', 'at': '[a-z]([a-zA-Z]\+\%#)',          'input': ' => {}<Left>',  })
" call add(s:rules, { 'filetype': ['typescript', 'javascript'], 'char': '>', 'at': '(.*[a-zA-Z]\+<[a-zA-Z]\+>\%#)', 'input': '<Left><C-o>f)<Right>a=> {}<Left>',  })

" タグのインデントをいい感じにする
call add(s:rules, { 'filetype': ['typescriptreact'], 'char': '<CR>', 'at': '<[a-zA-Z.]\+\(\s\)\?.*>\s*\%#\s*</[a-zA-Z.]\+\(\s\)\?.*>', 'input': '<CR><Esc>O<Tab>', })
call add(s:rules, { 'filetype': ['jsx'], 'char': '<CR>', 'at': '<[a-zA-Z.]\+\(\s\)\?.*>\s*\%#\s*</[a-zA-Z.]\+\(\s\)\?.*>', 'input': '<CR><Esc>O<Tab>', })


" =====================
" lexima で altercmd を実現する
" =====================
" https://scrapbox.io/vim-jp/lexima.vim%E3%81%A7Better_vim-altercmd%E3%82%92%E5%86%8D%E7%8F%BE%E3%81%99%E3%82%8B
function! s:lexima_alter_command(original, altanative) abort
  let input_space = '<C-w>' . a:altanative . '<Space>'
  let input_cr    = '<C-w>' . a:altanative . '<CR>'
  let rule = {
  \ 'mode': ':',
  \ 'at': '^\(''<,''>\)\?' . a:original . '\%#$',
  \ }
  call lexima#add_rule(extend(rule, { 'char': '<Space>', 'input': input_space }))
  call lexima#add_rule(extend(rule, { 'char': '<CR>',    'input': input_cr    }))
endfunction
command! -nargs=+ LeximaAlterCommand call <SID>lexima_alter_command(<f-args>)

" " ambicmd といっしょに使えるようにする設定？？？
" function! s:expand_command(key) abort
"   let key2char = { "\<Space>": ' ', "\<CR>": "\r" }
"   let key2lexima = { "\<Space>": '<Space>', "\<CR>": '<CR>' }
" 
"   let lexima = lexima#expand(key2lexima[a:key], ':')
"   if lexima !=# key2char[a:key]
"     return lexima
"   endif
" 
"   let ambicmd = ambicmd#expand(a:key)
"   if ambicmd !=# key2char[a:key]
"     return ambicmd
"   endif
" 
"   return a:key
" endfunction
" 
" cnoremap <expr> <Space> <SID>expand_command("\<Space>")
" cnoremap <expr> <CR>    <SID>expand_command("\<CR>")

LeximaAlterCommand g\%[it] Git
LeximaAlterCommand gc Git<space>commit<space>-m<space>""<Left>
LeximaAlterCommand gpush Git<space>push
LeximaAlterCommand gpull Git<space>pull
LeximaAlterCommand grep Telescope<space>live_grep
LeximaAlterCommand tel\%[e] Telescope
LeximaAlterCommand temp Template

for s:rule in s:rules
    call lexima#add_rule(s:rule)
endfor

"augroup my-lexima
"    autocmd!
"    autocmd FileType TelescopePrompt b:lexima_disabled = 1
"augroup END
