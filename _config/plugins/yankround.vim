scriptencoding utf-8

UsePlugin 'yankround.vim'

let g:yankround_max_history   = 10000
let g:yankround_use_region_hl = 1
let g:yankround_dir           = '~/.cache/nvim/yankround'

nmap p <Plug>(yankround-p)
xmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)

nmap <silent> <expr> <Left> yankround#is_active() ? '<Plug>(yankround-prev)' : '<Plug>(backandforward-back)'
nmap <silent> <expr> <Right> yankround#is_active() ? '<Plug>(yankround-next)' : "<Plug>(backandforward-forward)"

"nmap <Left> <Plug>(backandforward-back)
"nmap <Right> <Plug>(backandforward-forward)

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

