scriptencoding utf-8
" UsePlugin 'is.vim'
UsePlugin 'vim-asterisk'

" https://github.com/tsuyoshicho/vimrc-reading/blob/ad6df8bdac68ccbba4c0457797a1f9db56fcdca1/.vim/rc/dein.toml#L723-L847

" asterisk
let g:asterisk#keeppos = 1

" pulse
let g:vim_search_pulse_disable_auto_mappings = 1
" let g:vim_search_pulse_color_list = ['#3a3a3a', '#444444', '#4e4e4e', '#585858', '#606060']
" hsl(94, 40%, 23%)、hsl(94, 40%, 27%) 、、、
" 4% ずつ上がっている
let g:vim_search_pulse_color_list = ['#414550', '#494e5a', '#535865', '#5c6170', '#656b7b']

" nmap * <Plug>(asterisk-gz*)<Plug>Pulse
nmap * <Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR><Plug>Pulse
xmap * <Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>
omap * <Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>
nmap g* <Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR><Plug>Pulse
xmap g* <Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>
omap g* <Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>

nmap n n<Cmd>lua require('hlslens').start()<CR><Plug>Pulse
nmap N N<Cmd>lua require('hlslens').start()<CR><Plug>Pulse

" snoremap * *
" snoremap g* g*

nnoremap <Esc><Esc> <Cmd>nohlsearch<CR><Cmd>lua require('hlslens').stop()<CR>

" smartcase を使えないのがちょっとあれ
nmap gh <Plug>(modesearch-slash-regexp)
cmap <C-x> <Plug>(modesearch-toggle-mode)
