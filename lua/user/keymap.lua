local M = {}

M.set = function(keymap)
	vim.keymap.set("n", keymap[1], keymap[2], keymap[3])
end

M.set_list = function(keymaps)
	for _, keymap in ipairs(keymaps) do
		M.set(keymap)
	end
end

return M
