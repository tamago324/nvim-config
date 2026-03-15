if vim.api.nvim_call_function("FindPlugin", { "telescope.nvim" }) == 0 then
	do
		return
	end
end

local actions = require("telescope.actions")
local sorters = require("telescope.sorters")

require('telescope').setup({
  defaults = {
    layout_strategy = "bottom_pane",

		winblend = 0,
		sorting_strategy = "ascending",
		file_ignore_patterns = { "^node_modules/", "^vendor/", "^./node_modules" },

		layout_config = {
			prompt_position = "top",
			bottom_pane = {
				height = 30,
			},
		},

		results_title = false,
		preview_title = false,

		mappings = {
			-- insert mode のマッピング
			i = {
				-- 閉じる
				["<C-c>"] = actions.close,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<Esc>"] = actions.close,

				-- switch normal mode
				["<Tab>"] = function(_, _)
					local key = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
					vim.api.nvim_feedkeys(key, "n", true)
				end,

				-- カーソル移動
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,

				-- 開く
				["<C-t>"] = actions.select_tab,
				["<C-s>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<CR>"] = actions.select_default,

				["<C-l>"] = actions.toggle_selection + actions.move_selection_next,

				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
			},

			n = {
				-- カーソル移動
				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,

				["q"] = actions.close,
				["<Esc>"] = actions.close,

				-- 開く
				["<C-t>"] = actions.select_tab,
				["<C-s>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<CR>"] = actions.select_default,

				-- switch insert mode
				["<Tab>"] = function(_, _)
					vim.api.nvim_feedkeys("i", "n", true)
				end,

				-- 選択して、カーソル移動
				["J"] = actions.toggle_selection + actions.move_selection_next,
			},
    },
		set_env = {
			["COLORTERM"] = "truecolor",
			-- $ bat --list-themes で確認できる
			-- ["BAT_THEME"] = "gruvbox",
		},
  },
  extensions = {
		fzy_native = {
			override_generic_sorter = true,
			override_file_sorter = true,
		},
  }
})

local ext = function(name)
	return require("plugins/telescope/" .. name)
end
local n_commands, x_commands = ext("commands")()

-- カレントバッファから検索
local current_buffer_line = function()
	require("telescope.builtin").current_buffer_fuzzy_find({})
end

-- ファイルタイプを設定
local filetypes = function()
	require("telescope.builtin").filetypes({})
end

-- @Summary git_files か find_files
-- @Description
local find_files = function()
	local cwd = vim.fn.getcwd()
	local dir = require("lspconfig.util").find_git_ancestor(cwd)
	if dir == nil or dir == "" then
		require("telescope.builtin").find_files({
			-- layout_strategy = 'horizontal',
			cwd = cwd,
		})
	else
		require("telescope.builtin").git_files()
	end
end

-- @Summary vimfies から探す
-- @Description
local find_vimfiles = function()
	local cwd = vim.g.vimfiles_path
	-- local files = vim.tbl_map(function(v)
	-- 	-- /path/to/file .. '/'
	-- 	return v:sub(#cwd + 2)
	-- end, vim.fn["mr#filter"](vim.fn["mr#mru#list"](), cwd))

	require("telescope.builtin").find_files({
		cwd = cwd,
		-- previewer = previewers.cat.new({}),
	})
end

-- @Summary help tagas
-- @Description
local help_tags = function()
	require("telescope.builtin").help_tags({
		sorter = sorters.get_generic_fuzzy_sorter(),
	})
end



-- 

local map_ext = function(mode, lhs, name, opts)
  local mapp = function(_mode, _lhs, _rhs, _opts)
    vim.api.nvim_set_keymap(_mode, _lhs, _rhs, vim.tbl_extend("keep", _opts or {}, { silent = true, noremap = true }))
  end
	mapp(mode, lhs, string.format('<Cmd>lua require"plugins/telescope/%s"()<CR>', name), opts)
end

map_ext("n", ",f", "mru")
map_ext("n", "<Space>fj", "buffers")
map_ext("n", "<Space><Tab>", "ghq")

vim.keymap.set("n", "<Space>fv", find_vimfiles, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>ft", filetypes, { noremap = true, silent = true })
vim.keymap.set("n", "<Space>fh", help_tags, { noremap = true, silent = true })
vim.keymap.set("n", "<Space><CR>", n_commands, { noremap = true, silent = true })
vim.keymap.set("x", "<Space><CR>", x_commands, { noremap = true, silent = true })
vim.keymap.set("n", ",c", current_buffer_line, { noremap = true, silent = true })
vim.keymap.set("n", ",w", find_files, { noremap = true, silent = true })
