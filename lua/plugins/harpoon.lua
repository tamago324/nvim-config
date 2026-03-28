if vim.api.nvim_call_function("FindPlugin", { "harpoon" }) == 0 then
	do
		return
	end
end

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()

-- vim.keymap.set("n", "<Space><CR>", function()
-- 	harpoon.ui:toggle_quick_menu(harpoon:list())
-- end)

vim.keymap.set("n", "<Space>j", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", ",a", function()
	harpoon:list():add()
end)

vim.keymap.set("n", "1", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "2", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "3", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "4", function()
	harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<A-k>", function()
	harpoon:list():prev()
end)
vim.keymap.set("n", "<A-j>", function()
	harpoon:list():next()
end)
