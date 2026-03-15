local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")
local strdisplaywidth = require("plenary.strings").strdisplaywidth

local find_git_ancestor = require("lspconfig.util").find_git_ancestor
local ext_utils = require("plugins/telescope/utils")
local xmru = require("xmru")

local lir_float = require("lir.float")

local E = ext_utils

local devicons = require("nvim-web-devicons")

local gen_from_mru_better = function(opts)
	opts = opts or {}
	local default_icons, _ = devicons.get_icon("file", "", { default = true })
	local cwd = vim.fn.expand(opts.cwd or vim.fn.getcwd())

	-- local max_filename = math.max(unpack(vim.tbl_map(function(filepath)
	-- 	return strdisplaywidth(vim.fn.fnamemodify(filepath, ":p:t"))
	-- end, opts.results)))

	local root_dir
	do
		local dir = vim.fn.expand("%:p")
		if dir == "" then
			dir = vim.fn.getcwd()
		end
		root_dir = find_git_ancestor(dir)
	end

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 1 },
			-- { width = utils.strdisplaywidth(default_icons) },
			{ width = strdisplaywidth(default_icons) },
			-- { width = max_filename },
			{ width = 35 },
			{ remaining = true },
		},
	})

	-- local cwd = vim.fn.expand(opts.cwd or vim.fn.getcwd())

	-- リストの場合、ハイライトする
	local make_display = function(entry)
		return displayer({
			entry.mark_in_same_project,
			-- {entry.mark_win_info, 'WarningMsg'},
			{ entry.devicons, entry.devicons_highlight },
			entry.file_name,
			{ entry.dir_name, "Comment" },
		})
	end

	return function(entry)
		local dir_name = vim.fn.fnamemodify(entry, ":p:h")
		local file_name = vim.fn.fnamemodify(entry, ":p:t")

		local icons, highlight = devicons.get_icon(entry, string.match(entry, "%a+$"), {
			default = true,
		})

		-- プロジェクト内のファイルなら、印をつける
		-- 現在のバッファのプロジェクトを見つける
		local mark_in_same_project = " "
		if root_dir and root_dir ~= "" and vim.startswith(entry, root_dir) then
			mark_in_same_project = "*"
		elseif vim.startswith(entry, vim.g.vimfiles_path) then
			mark_in_same_project = "v"
		end

		-- local mark_win_info = ''
		-- local bufinfo = vim.fn.getbufinfo(entry.bufnr or 0)
		-- if entry.bufnr == vim.api.nvim_get_current_buf() then
		--   mark_win_info = '󿕅'
		-- elseif not vim.tbl_isempty(bufinfo) and not vim.tbl_isempty(bufinfo[1].windows) then
		--   mark_win_info = '󿠦'
		-- end

		return {
			valid = true,
			cwd = cwd,

			filename = entry,
			value = entry,
			-- バッファ番号、ファイル名のみ、検索できるようにする
			ordinal = file_name,
			display = make_display,

			-- bufnr = entry.bufnr,

			devicons = icons,
			devicons_highlight = highlight,

			file_name = file_name,
			dir_name = dir_name,

			mark_in_same_project = mark_in_same_project,
			-- mark_win_info = mark_win_info,
		}
	end
end

local function get_git_root()
	local root_dir
	local dir = vim.fn.expand("%:p")
	if dir == "" then
		dir = vim.fn.getcwd()
	end
	root_dir = find_git_ancestor(dir)

	return root_dir
end

-- ---git リポジトリかどうか
-- ---@return any
-- local function is_git_project()
-- 	local dir = get_git_root()
-- 	return dir and dir ~= ""
-- end

local function list(only_git_files)
	local files = vim.fn["mr#mru#list"]()
	local git_root = get_git_root()
	if git_root and only_git_files then
		return vim.fn["mr#filter"](files, git_root)
	end
	return files
end

-- @Summary mru
-- @Description
return function(opts)
	opts = vim.F.if_nil(opts, {})
	local results = list(opts.only_git_files)

	pickers.new({}, {
		prompt_title = "MRU",
		finder = finders.new_table({
			results = results,
			entry_maker = gen_from_mru_better({ results = results }),
		}),
		-- layout_strategy = 'vertical',
		file_ignore_patterns = { "^/tmp" },
		-- previewer = previewers.cat.new({}),
		previewer = false,
		-- sorter = conf.generic_sorter({}),
		sorter = E.get_fzy_sorter_use_list({
			list = xmru.list(),
			get_needle = function(entry)
				return entry.filename
			end,
		}),
		-- entry_maker = make_entry.gen_from_file(),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(E.smart_open(prompt_bufnr, "drop", "hide edit"))
			actions.select_horizontal:replace(E.smart_open(prompt_bufnr, "new", "new"))
			actions.select_vertical:replace(E.smart_open(prompt_bufnr, "vnew", "vnew"))
			actions.select_tab:replace(E.smart_open(prompt_bufnr, "tabedit", "tabedit"))

			local open_lir = function()
				local entry = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				lir_float.init(entry.dir_name)
			end

			map("i", "<C-e>", open_lir)

			return true
		end,
	}):find()
end

