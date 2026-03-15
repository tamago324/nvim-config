scriptencoding utf-8
UsePlugin 'ddt.vim'

call ddt#custom#patch_global(#{
      \   uiParams: #{
      \     shell: #{
      \       nvimServer: '~/.cache/nvim/server.pipe',
      \       prompt: '=\\\>',
      \       promptPattern: '\w*=\\\> \?',
      \     },
      \     terminal: #{
      \       nvimServer: '~/.cache/nvim/server.pipe',
      \       command: ['bash'],
      \       promptPattern: has('win32') ? '\f\+>' : '\w*% \?',
      \     },
      \   },
      \ })
