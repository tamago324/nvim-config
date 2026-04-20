if vim.api.nvim_call_function("FindPlugin", { "lir.nvim" }) == 0 then
	do
		return
	end
end

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
local states = {}

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
	end

	local cmd = "edit"
	vim.cmd(string.format("%s %s %s", keepalt, cmd, vim.fn.fnameescape(dir .. file)))
	history.add(dir, file)
end

-- float を考慮しつつ、split もいい感じにする
local keep_open = function(action)
	return function()
		local quit = (vim.w.lir_is_float and true) or false
		action(quit)
	end
end

-- 最後に表示していたディレクトリを保持しておくことですぐに開けるようにする
local quit = function()
	states.last_dir = lir.get_context().dir
	actions.quit()
end

local is_hide_term = function(buf)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			return false
		end
	end
	return true
end

-- Snacks terminal で cd する
local term_cd = function(dir)
	-- 取得 or 作成
	local term = Snacks.terminal.get()
	if not term or is_hide_term(term.buf) then
		Snacks.terminal.open()
	end

	assert(term)
	if not term.buf then
		return
	end

	-- term.buf のターミナルに対して、送信できる
	local channel = vim.bo[term.buf].channel
	vim.api.nvim_chan_send(channel, string.char(21)) -- <C-u> を送る (Ctrl-Aが1だから、21)
	vim.fn.chansend(channel, string.format("cd %s\n", dir))
end

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
		["<C-s>"] = keep_open(actions.split),
		["<C-v>"] = keep_open(actions.vsplit),
		["<C-t>"] = keep_open(actions.tabedit),
		["gf"] = xactions.goto_git_root,
		["h"] = actions.up,
		["q"] = function()
			actions.reload()
		end,
		["<Esc>"] = quit,

		["cd"] = function()
			feedkeys(":e ")
		end,
		K = xactions.newfile,
		R = xactions.rename_and_jump,

		["@"] = xactions.cd,

		["<A-o>"] = function()
			local ctx = lir.get_context()
			local dir = ctx.dir
			quit()
			term_cd(dir)
		end,

		["Y"] = actions.yank_path,
		["."] = actions.toggle_show_hidden,

		["~"] = function()
			vim.cmd("edit " .. vim.fn.expand("$HOME"))
		end,

		["J"] = function()
			m.toggle_mark()
			vim.cmd("normal! j")
		end,
		["C"] = c.copy,
		["X"] = c.cut,
		P = c.paste,
		["D"] = xactions.delete,
		-- python3 -m pip install --user --upgrade neovim-remote
		-- ["M"] = mmv,

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
		--	 vim.cmd("Fin -matcher=fuzzy")
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
				border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
				-- https://en.wikipedia.org/wiki/Box-drawing_character の 3 の縦棒を基準にする
				-- border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
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
	get_filters = nil,
})

function _G._LirSetTextFloatCurdirWindow()
	if vim.w.lir_is_float then
		local virt_text = {}
		if lir_config.values.show_hidden_files then
			virt_text = { { "󿜇 ", "WarningMsg" } }
		else
			virt_text = { { "󿜈 ", "Comment" } }
		end

		local bufnr = vim.w.lir_curdir_win.bufnr
		local line = (vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or "")
		local col = math.min(1, #line)
		local end_col = math.max(col, math.min(2, #line))
		vim.api.nvim_buf_set_extmark(bufnr, ns, 0, col, {
			end_col = end_col,
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

_G.x_lir_init = function()
	local dir = nil
	-- local bufname = vim.fn.bufname()
	-- states.last_buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	if dir == nil and vim.fn.isdirectory(vim.fn.expand("%:p:h")) == 0 then
		-- もし、存在しないなら、HOME を表示する
		dir = vim.fn.expand("~")
	end
	require("lir.float").toggle(dir)
	xpreview.on()
end

require("xlir.persist_history").setup()

vim.api.nvim_set_keymap("n", "<C-e>", "<Cmd>lua _G.x_lir_init()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", ",e", function()
	vim.cmd([[edit .]])
end, { silent = true, remap = false })

vim.keymap.set("n", "H", function()
	local conn = require("sshfs").get_active()
	if conn then
		require("lir.float").toggle(conn.mount_path)
		xpreview.on()
	end
end)
