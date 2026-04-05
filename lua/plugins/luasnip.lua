if vim.api.nvim_call_function("FindPlugin", { "LuaSnip" }) == 0 then
	do
		return
	end
end
local luasnip = require("luasnip")
local types = require("luasnip.util.types")

luasnip.config.setup({
	history = false,
	-- ext_opts = {
	--   [types.choiceNode] = {
	--     active ={
	--       virt_text = {{ '  ', 'Error' }}
	--     }
	--   }
	-- },
	updateevents = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged",
})

vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if luasnip.jumpable(-1) then
		luasnip.jump(-1)
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-n>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(1)
	end
end, { silent = true })

-- require("luasnip.loaders.from_vscode").lazy_load()

function _G.LuaSnipAllLoad()
	require("luasnip.loaders.from_lua").load({ paths = { vim.g.vimfiles_path .. "/snippets" } })
end
vim.cmd([[command! LuaSnipAllLoad lua LuaSnipAllLoad()]])
LuaSnipAllLoad()

function _G.LuaSnipOpen()
	local ft = string.gsub(vim.bo.filetype, "%.", "_")
	local file = string.format("%s/snippets/%s.lua", vim.g.vimfiles_path, ft)
	vim.cmd("split " .. file)
end

vim.cmd([[command! LuaSnipOpen lua LuaSnipOpen()]])

-- -- 指定のパスの snippet を読み込む
-- require("luasnip.loaders.from_vscode").load({
-- 	paths = {
-- 		vim.g.vimfiles_path .. "/snippets/luasnip",
-- 	},
-- })

-- require('luasnip/choice_mark').setup_autocmds()
