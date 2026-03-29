if vim.api.nvim_call_function("FindPlugin", { "lir.nvim" }) == 0 then
	do
		return
	end
end

-- do
--   return
-- end

local a = vim.api

local lir = require("lir")
-- local mmv = require("lir.mmv.actions").mmv
-- local b = require("lir.bookmark.actions")
local m = require("lir.mark.actions")
local c = require("lir.clipboard.actions")
local history = require("lir.history")
local lir_config = require("lir.config")
local uv = vim.loop

local actions = require("lir.actions")
local xactions = require("xlir.actions")
local xpreview = require("xlir.float_preview")
-- local tsserver_rename = require("xlir.actions.tsserver_rename")

local ns = vim.api.nvim_create_namespace("my_lir")

require("lir.git_status").setup({
	show_ignored = true,
})

---@class my_lir_states
---@field last_dir string
local states = {
	mod_mode = false,
}

local function feedkeys(key)
	a.nvim_feedkeys(a.nvim_replace_termcodes(key, true, false, true), "n", true)
end

local function nop() end

local explorer = function()
	local ctx = lir.get_context()
	if vim.fn.has("win64") == "1" then
		vim.fn.system(string.format("start %s", ctx.dir))
	elseif os.getenv("WSL_DISTRO_NAME") ~= "" then
		local win_path = vim.fn.system({ "wslpath", "-w", ctx.dir })
		-- バックスラッシュを正しく考慮できるように、systemlist を使う
		vim.fn.systemlist({ "explorer.exe", win_path })
	else
		vim.fn.system(string.format("xdg-open %s", ctx.dir))
	end
end

-- local wipeout = function()
--   local ctx = lir.get_context()
--   local bufnr = vim.fn.bufnr(ctx:current_value())
--   if bufnr ~= -1 then
--     vim.api.nvim_buf_delete(bufnr, {force = true})
--   end
--   actions.delete()
-- end

-- deol のバッファを考慮して、開く
local open = function()
	local ctx = lir.get_context()
	local dir, file = ctx.dir, ctx:current_value()
	if not file then
		return
	end

	local keepalt = (vim.w.lir_is_float and "") or "keepalt"

	if vim.w.lir_is_float and not ctx:is_dir_current() then
		-- 閉じてから開く
		actions.quit()
		-- float を開いたときのウィンドウに移動する
		vim.api.nvim_set_current_win(vim.t.lir_float_origin_winid)
	end

	local cmd = "edit"
	vim.cmd(string.format("%s %s %s", keepalt, cmd, vim.fn.fnameescape(dir .. file)))
	history.add(dir, file)
end

-- 最後に表示していたディレクトリを保持しておくことですぐに開けるようにする
local quit = function()
	states.last_dir = lir.get_context().dir
	actions.quit()
	-- float を開いたときのウィンドウに移動する
	if vim.api.nvim_win_is_valid(vim.t.lir_float_origin_winid) then
		vim.api.nvim_set_current_win(vim.t.lir_float_origin_winid)
	else
		vim.t.lir_float_origin_winid = nil
	end
end

-- -- 対象のファイルに対応する tsserver が起動しているかどうかをチェックする
-- local is_started_tsserver = function()
-- 	return tsserver_rename.get_client(lir.get_context().dir) ~= nil
-- end

require("lir").setup({
	hide_cursor = vim.fn.has("win64") == 0,
	ignore = {
		"__pycache__",
		"node_modules",
	},
	show_hidden_files = false,
	devicons = {
		enable = true,
		highlight_dirname = false,
	},
	mappings = {
		-- ["u"] = nop,
		["U"] = nop,
		["o"] = nop,
		["r"] = nop,
		-- ["p"] = nop,
		["i"] = nop,
		-- ["I"] = nop,
		["x"] = nop,

		["<CR>"] = function()
			-- vim.fn["searchx#start"]({ dir = 1 })
			vim.fn.feedkeys("/", "n")
		end,

		["l"] = open,
		["<C-s>"] = actions.split,
		["<C-v>"] = actions.vsplit,
		["<C-t>"] = actions.tabedit,
		["gf"] = xactions.goto_git_root,
		["h"] = actions.up,
		["q"] = function()
			states.mod_mode = false
			actions.reload()
		end,
		["<Esc>"] = quit,

		["cd"] = function()
			feedkeys(":e ")
		end,
		K = xactions.newfile,
		R = xactions.rename_and_jump,
		-- ["R"] = function()
		-- 	if is_started_tsserver() then
		-- 		-- qflist に出力するための準備
		-- 		local qflist_id = tsserver_rename.getqflist_id()
		-- 		tsserver_rename.change_workspace_applyedit_handler(qflist_id)
		--
		-- 		tsserver_rename.rename()
		-- 		return
		-- 	end
		--
		-- 	xactions.rename()
		-- end,
		-- ["R"] = actions.rename,
		-- ["tr"] = require("xlir.actions.simple_tsserver_rename").rename,
		["@"] = xactions.cd,

		-- ["<A-d>"] = function()
		-- 	local dir = lir.get_context().dir
		-- 	vim.fn.system("wezterm.exe cli split-pane --cwd " .. dir)
		-- end,

		["Y"] = actions.yank_path,
		["."] = actions.toggle_show_hidden,

		["~"] = function()
			vim.cmd("edit " .. vim.fn.expand("$HOME"))
		end,

		-- ["B"] = b.list,
		-- ["ba"] = b.add,

		["J"] = function()
			m.toggle_mark()
			vim.cmd("normal! j")
		end,
		["C"] = c.copy,
		["X"] = c.cut,
		P = c.paste,
		-- ["P"] = function()
		-- 	c.paste()
		--
		-- 	-- tsserver_rename を実行する
		-- 	local ctx = lir.get_context()
		-- 	local tsserver_client = tsserver_rename.get_client(ctx.dir)
		-- 	if tsserver_client == nil then
		-- 		return
		-- 	end
		--
		-- 	local qflist_id = tsserver_rename.getqflist_id()
		-- 	for _, file in ipairs(ctx.pasted_files) do
		-- 		-- qflist に出力するための準備
		-- 		tsserver_rename.change_workspace_applyedit_handler(qflist_id)
		-- 		tsserver_rename.execute_command_rename_file(tsserver_client, file.source_path, file.target_path)
		-- 	end
		-- end,
		["D"] = xactions.delete,
		-- ["D"] = actions.delete,
		-- python3 -m pip install --user --upgrade neovim-remote
		-- ["M"] = mmv,
		-- ["M"] = function()
		-- 	states.mod_mode = not states.mod_mode
		-- 	actions.reload()
		-- 	pprint(states.mod_mode and "並び順: 更新順" or "並び順: 標準")
		-- end,

		["dd"] = actions.wipeout,

		-- ["yy"] = require("plugins.telescope.lir_yank_path"),

		["!"] = explorer,

		["u"] = function()
			if states.last_dir then
				vim.cmd("e " .. states.last_dir)
			end
		end,

		-- 現在のディレクトリを通常のバッファで2つ開く
		["S"] = function()
			local dir = lir.get_context().dir
			actions.quit()

			vim.cmd("tabnew")
			vim.cmd("e " .. dir)
			vim.cmd("vs")
		end,

		["T"] = actions.touch,

		-- ["<CR>"] = function()
		--   vim.cmd("Fin -matcher=fuzzy")
		-- end

		["p"] = xpreview.toggle,
		["I"] = xactions.image_paste,
		["-"] = xactions.git.stage_toggle,
		["mo"] = function()
			local ctx = lir.get_context()
			local path = ctx:current().fullpath
			if ctx:is_dir_current() then
				path = path .. "/*.md"
			end
			vim.cmd("new | terminal mo " .. path)
		end,
	},
	float = {
		winblend = 0,
		curdir_window = {
			enable = true,
			highlight_dirname = true,
		},

		-- You can define a function that returns a table to be passed as the third
		-- argument of nvim_open_win().
		win_opts = function()
			local width = math.floor(vim.o.columns * 0.8)
			local height = math.floor(vim.o.lines * 0.6)
			-- 最大の幅を調整
			width = (width > 140 and 140) or width

			return {
				-- border = { "┌", "─", "┐", "│", "┘", "─", "└", "│", },
				-- https://en.wikipedia.org/wiki/Box-drawing_character の 3 の縦棒を基準にする
				border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
				width = width,
				height = height,
			}
		end,
	},
	on_init = function()
		vim.api.nvim_buf_set_keymap(
			0,
			"x",
			"J",
			':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
			{ noremap = true, silent = true }
		)

		vim.api.nvim_buf_set_keymap(0, "x", "W", "", {
			noremap = true,
			callback = function()
				m.toggle_mark("v")
				c.copy()
			end,
		})
	end,

	get_filters = function()
		if not states.mod_mode then
			return {}
		end

		return {
			function(files)
				-- https://www.man7.org/linux/man-pages/man2/stat.2.html
				-- mtime: 最終更新日時
				-- mtime.sec でソートする

				files = vim.tbl_map(function(f)
					local mtime = uv.fs_stat(f.fullpath).mtime or nil
					f.mod_time = mtime.sec
					return f
				end, files)

				local function sort(lhs, rhs)
					if lhs.is_dir and not rhs.is_dir then
						return true
					elseif not lhs.is_dir and rhs.is_dir then
						return false
					elseif lhs.is_dir and rhs.is_dir then
						-- どちらともディレクトリなら、アルファベット順
						return lhs.value < rhs.value
					end
					return lhs.mod_time > rhs.mod_time
				end

				table.sort(files, sort)
				return files
			end,
		}
	end,
})

function _G._LirSetTextFloatCurdirWindow()
	if vim.w.lir_is_float then
		local virt_text = {}
		if lir_config.values.show_hidden_files then
			virt_text = { { "󿜇 ", "WarningMsg" } }
		else
			virt_text = { { "󿜈 ", "Comment" } }
		end

		if states.mod_mode then
			table.insert(virt_text, { " M", "WarningMsg" })
		end

		local bufnr = vim.w.lir_curdir_win.bufnr
		vim.api.nvim_buf_set_extmark(bufnr, ns, 0, 1, {
			end_col = 2,
			virt_text = virt_text,
		})
	end
end

vim.api.nvim_exec(
	[[
augroup my-lir
  autocmd!
  autocmd User LirSetTextFloatCurdirWindow lua _LirSetTextFloatCurdirWindow()
augroup END
]],
	false
)

-- require("lir.bookmark").setup({
-- 	bookmark_path = "~/.lir_bookmark",
-- 	mappings = {
-- 		["l"] = b.edit,
-- 		["<C-s>"] = b.split,
-- 		["<C-v>"] = b.vsplit,
-- 		["<C-t>"] = b.tabedit,
-- 		["<C-e>"] = b.open_lir,
-- 		["B"] = b.open_lir,
-- 		["q"] = b.open_lir,
-- 	},
-- })

_G.x_lir_init = function()
	local dir = nil
	local bufname = vim.fn.bufname()
	states.last_buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	if bufname:match("deol%-edit@") or bufname:match("term://") then
		dir = vim.fn.getcwd()
	end

	if dir == nil and vim.fn.isdirectory(vim.fn.expand("%:p:h")) == 0 then
		-- もし、存在しないなら、HOME を表示する
		dir = vim.fn.expand("~")
	end
	require("lir.float").toggle(dir)
	xpreview.on()
end

require("xlir.persist_history").setup()

vim.api.nvim_set_keymap("n", "<C-e>", "<Cmd>lua _G.x_lir_init()<CR>", { silent = true, noremap = true })
