if vim.api.nvim_call_function("FindPlugin", { "grug-far.nvim" }) == 0 then
	do
		return
	end
end

require('grug-far').setup({})

vim.keymap.set('n', '<Space>fg', ':<C-u>GrugFar ')
