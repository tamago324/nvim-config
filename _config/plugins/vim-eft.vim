scriptencoding utf-8
UsePlugin 'vim-eft'

if empty(globpath(&rtp, 'autoload/eft.vim'))
    finish
endif

let g:eft_ignorecase = v:true

let g:eft_highlight = {
\   '1': {
\     'highlight': 'EftChar',
\     'allow_space': v:true,
\     'allow_operator': v:true,
\   },
\   '2': {
\     'highlight': 'EftSubChar',
\     'allow_space': v:false,
\     'allow_operator': v:false,
\   },
\   'n': {
\     'highlight': 'EftSubChar',
\     'allow_space': v:false,
\     'allow_operator': v:false,
\   }
\ }

" If you prefer clever-f style repeat.
nmap f <Plug>(eft-f-repeatable)
xmap f <Plug>(eft-f-repeatable)
omap f <Plug>(eft-f-repeatable)
nmap F <Plug>(eft-F-repeatable)
xmap F <Plug>(eft-F-repeatable)
omap F <Plug>(eft-F-repeatable)

" nmap t <Plug>(eft-t-repeatable)
" xmap t <Plug>(eft-t-repeatable)
" omap t <Plug>(eft-t-repeatable)
" nmap T <Plug>(eft-T-repeatable)
" xmap T <Plug>(eft-T-repeatable)
" omap T <Plug>(eft-T-repeatable)


