scriptencoding utf-8
UsePlugin 'denops.vim'

let g:my_denops_debug = v:false

if get(g:, 'my_denops_debug', v:false)
  let g:denops#server#deno_args = [
  \ '-q',
  \ '--unstable-ffi',
  \ '--no-check',
  \ '-A',
  \]
  "\ '--inspect',
  let g:denops#debug = v:true
endif


