scriptencoding utf-8
UsePlugin 'denops-signature_help'

call signature_help#enable()

let g:signature_help_config = {
\ "contentsStyle": "labels",
\ "style": "virtual",
\}

let s:denops_signature_help_ignore_filetype = ['vim']
function! s:enable_signiture_help() abort
  if index(s:denops_signature_help_ignore_filetype, &filetype) == -1
    call signature_help#enable()
  else
    call signature_help#disable()
  endif
endfunction
autocmd FileType * call s:enable_signiture_help()

