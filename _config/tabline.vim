scriptencoding utf-8

set tabline=%!MyTabLine()

function! MyTabLine() abort
  let l:s = ''
  for i in range(tabpagenr('$'))
    " カレントタブの強調表示
    if i + 1 == tabpagenr()
      let l:s .= '%#TabLineSel#'
    else
      let l:s .= '%#TabLine#'
    endif

    " タブページの番号
    let s .= '%' .. (i + 1) . 'T'

    " タブのテキスト
    " TODO: 太字
    let s .= printf(' %d ', (i+1))
  endfor

  let s .= '%#TabLineFill#%T'

  return s
endfunction
