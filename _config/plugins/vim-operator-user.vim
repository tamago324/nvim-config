scriptencoding utf-8
UsePlugin 'vim-operator-user'


if FindPlugin('vim-operator-replace')
  map R <Plug>(operator-replace)
endif

if FindPlugin('vim-operator-convert-case')
  nmap ,c <Plug>(convert-case-loop)
endif
