scriptencoding utf-8
UsePlugin 'vim-quickrun'

let g:quickrun_config = {}

" Windows の場合、コマンドの出力は cp932 のため
" (vimとかは内部で実行しているため、utf-8にする必要がある)
" hook/output_encode/encoding で encoding の from:to を指定できる
let g:quickrun_config = {
\   '_': {
\       'runner': has('nvim') ? 'neovim_job' : 'job',
\       'hook/output_encode/encoding': has('win32') ? 'cp932' : 'utf-8',
\       'outputter/buffer': 1,
\       'outputter/buffer/close_on_empty': 1,
\       'runner/nvimterm/opener': 'new',
\   },
\   'vim': {
\       'hook/output_encode/encoding': '&fileencoding',
\   },
\   'nim': {
\       'hook/output_encode/encoding': '&fileencoding',
\   },
\   'python': {
\       'exec': has('win32') ? 'py -3 %s %a' : 'python3.10 %s %a',
\       'hook/output_encode/encoding': '&fileencoding',
\   },
\   'scheme': {
\       'exec': 'gosh %s',
\   },
\   'c': {
\       'command': 'clang',
\       'exec': has('win32') ? ['%c %o %s:p', 'a.exe %a'] : ['%c %o %s:p', './a.out %a'],
\       'tempfile': '%{tempname()}.c',
\       'hook/sweep/files': '%S:p:r',
\       'cmdopt': '-Wall',
\   },
\   'haskell': {
\       'command': 'stack',
\       'cmdopt': 'runhaskell',
\   },
\   'lua': {
\       'type': 'lua/vim'
\   },
\   'zig': {
\       'exec': 'zig run %s'
\   },
\   'zig/test': {
\       'exec': 'zig test %s',
\       'outputter': 'quickfix',
\   },
\   'ts/deno': {
\       'exec': 'deno run --allow-read --allow-write --allow-net %s',
\       'runner': 'nvimterm',
\   },
\   'ruby.rspec': {
\       'command': 'bundle',
\       'cmdopt': 'exec rspec -f d',
\       'runner': 'nvimterm',
\   },
\   'go.test': {
\       'command': 'go',
\       'cmdopt': 'test -v',
\       'outputter': 'quickfix',
\   },
\   'typescriptreact': {
\       'command': 'pnpm',
\       'cmdopt': 'jest %s',
\   },
\   'go': {
\       'command': 'go',
\       'exec': ['%c run %s'],
\   }
\}

" \   'c': {
" \       'exec': 'clang.exe %s && a'
" \   }
" \   'rust': {
" \       'exec': 'cargo run'
" \   }

nmap <Space>rr <Plug>(quickrun)

command! QRHookUtf8 let b:quickrun_config = {'hook/output_encode/encoding': 'utf8'}

nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

" function! s:setup_exercism_php(file) abort
"   " /home/username/exercism/php/hamming/Hamming.php
"   "                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
" 
"   let l:exercism_php_dir = expand('~/exercism/php')
" 
"   let b:quickrun_config = {
"  \ 'command': l:exercism_php_dir .. '/vendor/bin/phpunit',
"  \ 'srcfile':fnamemodify(a:file, ':p:r') .. 'Test.php',
"  \ 'exec': '%c %s',
"  \ 'runner': 'nvimterm',
"  \ 'hook/cd/directory': l:exercism_php_dir,
"  \}
" endfunction
" augroup my-quickrun-exercism-php
"   autocmd!
"   autocmd BufEnter ~/exercism/php/*/*.php call <SID>setup_exercism_php(expand('<afile>'))
" augroup END
