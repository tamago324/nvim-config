scriptencoding utf-8

UsePlugin 'yankround.vim'

" nmap p <Plug>(yankround-p)
" xmap p <Plug>(yankround-p)
" nmap P <Plug>(yankround-P)
" nmap gp <Plug>(yankround-gp)
" xmap gp <Plug>(yankround-gp)
" nmap gP <Plug>(yankround-gP)
" nmap <C-p> <Plug>(yankround-prev)
" nmap <C-n> <Plug>(yankround-next)

let g:yankround_max_history   = 10000
let g:yankround_use_region_hl = 1
let g:yankround_dir           = '~/.cache/nvim/yankround'

nmap p <Plug>(yankround-p)
xmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)

nmap <silent> <expr> <C-p> yankround#is_active() ? '<Plug>(yankround-prev)' : '<C-p>'
nmap <silent> <expr> <C-n> yankround#is_active() ? '<Plug>(yankround-next)' : "<C-n>"

function! s:keymap(force_map, modes, ...) abort
  let arg = join(a:000, ' ')
  let cmd = (a:force_map || arg =~? '<Plug>') ? 'map' : 'noremap'
  for mode in split(a:modes, '.\zs')
    if index(split('nvsxoilct', '.\zs'), mode) < 0
      echoerr 'Invalid mode is detected: ' . mode
      continue
    endif
    execute mode . cmd arg
  endfor
endfunction

command! -nargs=+ -bang Keymap call <SID>keymap(<bang>0, <f-args>)

