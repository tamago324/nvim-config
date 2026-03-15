" INSERT モードを抜けたら、IME OFF
autocmd InsertLeave * call <SID>ime_off()
function! s:ime_off()
  let l:shell = &shell
  let &shell='/usr/bin/bash --login'
  call system('/mnt/c/Users/tamago324/tools/zenhan.exe 0')
  let &shell = l:shell
endfunction
