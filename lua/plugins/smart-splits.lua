if vim.api.nvim_call_function("FindPlugin", { "smart-splits.nvim" }) == 0 then
	do
		return
	end
end

-- smart split は、 Neovim と WezTerm のパネルの行き来を同じキーバインドでできるようにしてくれる！

-- wezterm は nightly が必須
-- wezterm CLI も必要 (/mnt/c/Program\ Files/WezTerm/wezterm.exe に入っている)
vim.env.PATH = vim.env.PATH .. ':/mnt/c/Program Files/WezTerm'

require('smart-splits').setup({
  ignore_filetypes = {'lir'}
})

-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
vim.keymap.set('n', '<A-Left>', require('smart-splits').resize_left)
vim.keymap.set('n', '<A-Down>', require('smart-splits').resize_down)
vim.keymap.set('n', '<A-Up>', require('smart-splits').resize_up)
vim.keymap.set('n', '<A-Right>', require('smart-splits').resize_right)
-- moving between splits
vim.keymap.set('n', '<A-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<A-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<A-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<A-l>', require('smart-splits').move_cursor_right)
-- vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
-- swapping buffers between windows
vim.keymap.set('n', '<A-S-h>', require('smart-splits').swap_buf_left)
vim.keymap.set('n', '<A-S-j>', require('smart-splits').swap_buf_down)
vim.keymap.set('n', '<A-S-k>', require('smart-splits').swap_buf_up)
vim.keymap.set('n', '<A-S-l>', require('smart-splits').swap_buf_right)
