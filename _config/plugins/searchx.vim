scriptencoding utf-8

UsePlugin 'vim-searchx'

let g:searchx = {}

" let g:searchx.auto_accept = v:true

let g:searchx.scrolloff = 10

" いい感じにスクロールする
let g:searchx.scrolltime = 300

" " Overwrite / and ?.
" nnoremap ? <Cmd>call searchx#start({ 'dir': 0 })<CR>
" nnoremap / <Cmd>call searchx#start({ 'dir': 1 })<CR>
" xnoremap ? <Cmd>call searchx#start({ 'dir': 0 })<CR>
" xnoremap / <Cmd>call searchx#start({ 'dir': 1 })<CR>
" 
" " Move to next/prev match.
" nnoremap N <Cmd>call searchx#prev_dir()<CR>
" nnoremap n <Cmd>call searchx#next_dir()<CR>
" xnoremap N <Cmd>call searchx#prev_dir()<CR>
" xnoremap n <Cmd>call searchx#next_dir()<CR>
" 
" " Clear highlights
" nnoremap <Esc><Esc> <Cmd>call searchx#clear()<CR>
" 
" cnoremap <C-k> <Cmd>call searchx#prev()<CR>
" cnoremap <C-j> <Cmd>call searchx#next()<CR>

" augroup my-seak
"   autocmd!
"   autocmd CmdlineEnter /,\? cnoremap <buffer><C-k> <Cmd>call searchx#prev()<CR>
"   autocmd CmdlineEnter /,\? cnoremap <buffer><C-j> <Cmd>call searchx#next()<CR>
"   " autocmd CmdlineEnter /,\? cnoremap <buffer>; <Cmd>call searchx#select()<CR>
"   
"   " autocmd CmdlineLeave /,\? cunmap <buffer> /
"   " autocmd CmdlineLeave /,\? cunmap <buffer> /
" augroup END

" let g:searchx = {}
" 
" " let g:searchx.auto_accept = v:true
" 
" let g:searchx.scrolloff = 10
" 
" " いい感じにスクロールする
" let g:searchx.scrolltime = 300
" 
" let g:searchx.markers = split('ASDFGWERXCVBHJKLPUIO', '.\zs')

" Customize behaviors.
" function g:searchx.convert(input) abort
"   if a:input !~# '\k'
"     return '\V' .. a:input
"   endif
"   let l:sep = a:input[0] =~# '[[:alnum:]]' ? '\%([^[:alnum:]]\|^\)\zs' : '\%([[:alnum:]]\|^\)\?\zs'
"   return l:sep .. join(split(a:input, ' '), '.\{-}')
" endfunction


" function! s:has(list, value) abort
"   return index(a:list, a:value) isnot -1
" endfunction
" function! s:_get_unary_caller(f) abort
"   return type(a:f) is type(function('function'))
"  \        ? function('call')
"  \        : function('s:_call_string_expr')
" endfunction
" function! s:_call_string_expr(expr, args) abort
"   return map([a:args[0]], a:expr)[0]
" endfunction
" function! s:sort(list, f) abort
"   if type(a:f) is type(function('function'))
"     return sort(a:list, a:f)
"   else
"     let s:sort_expr = a:f
"     return sort(a:list, 's:_compare_by_string_expr')
"   endif
" endfunction
" function! s:_compare_by_string_expr(a, b) abort
"   return eval(s:sort_expr)
" endfunction
" function! s:uniq(list) abort
"   return s:uniq_by(a:list, 'v:val')
" endfunction
" function! s:uniq_by(list, f) abort
"   let l:Call  = s:_get_unary_caller(a:f)
"   let applied = []
"   let result  = []
"   for x in a:list
"     let y = l:Call(a:f, [x])
"     if !s:has(applied, y)
"       call add(result, x)
"       call add(applied, y)
"     endif
"     unlet x y
"   endfor
"   return result
" endfunction
" function! s:product(lists) abort
"   let result = [[]]
"   for pool in a:lists
"     let tmp = []
"     for x in result
"       let tmp += map(copy(pool), 'x + [v:val]')
"     endfor
"     let result = tmp
"   endfor
"   return result
" endfunction
" function! s:permutations(list, ...) abort
"   if a:0 > 1
"     throw 'vital: Data.List: too many arguments'
"   endif
"   let r = a:0 == 1 ? a:1 : len(a:list)
"   if r > len(a:list)
"     return []
"   elseif r < 0
"     throw 'vital: Data.List: {r} must be non-negative integer'
"   endif
"   let n = len(a:list)
"   let result = []
"   for indices in s:product(map(range(r), 'range(n)'))
"     if len(s:uniq(indices)) == r
"       call add(result, map(indices, 'a:list[v:val]'))
"     endif
"   endfor
"   return result
" endfunction
" function! s:combinations(list, r) abort
"   if a:r > len(a:list)
"     return []
"   elseif a:r < 0
"     throw 'vital: Data.List: {r} must be non-negative integer'
"   endif
"   let n = len(a:list)
"   let result = []
"   for indices in s:permutations(range(n), a:r)
"     if s:sort(copy(indices), 'a:a - a:b') == indices
"       call add(result, map(indices, 'a:list[v:val]'))
"     endif
"   endfor
"   return result
" endfunction
" 
" function! s:fuzzy_query(input) abort
"   if match(a:input, ';') == -1
"     return [a:input]
"   endif
"   let input = substitute(a:input, ';', '', 'g')
"   let trigger_count = len(a:input) - len(input)
"   let arr = range(1, len(input) - 1)
"   let result = []
"   for ps in s:combinations(arr, trigger_count)
"     let ps = reverse(ps)
"     let str = input
"     for p in ps
"       let str = str[0 : p - 1] . ' ' . str[p : -1]
"     endfor
"     let result += [str]
"   endfor
"   return result
" endfunction
" 
" function! g:searchx.convert(input) abort
"   if a:input !~# '\k'
"     return '\V' .. a:input
"   endif
"   if a:input =~# ';'
"     let max_score = 0
"     for q in s:fuzzy_query(a:input)
"       let targets = denops#request('fuzzy-motion', 'targets', [q])
"       if len(targets) > 0 && targets[0].score > max_score
"         let max_score = targets[0].score
"         let fuzzy_input = join(split(q, ' '), '.\{-}')
"       endif
"     endfor
"     return fuzzy_input ==# '' ? a:input : fuzzy_input
"   endif
"   return join(split(a:input, ' '), '.\{-}')
" endfunction
