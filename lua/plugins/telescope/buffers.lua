local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")
local strdisplaywidth = require("plenary.strings").strdisplaywidth

local find_git_ancestor = require("lspconfig.util").find_git_ancestor
local ext_utils = require("plugins/telescope/utils")

local smart_open = ext_utils.smart_open

local devicons = require("nvim-web-devicons")

-- 表示したくないバッファ
local invalid_regex_list = { "^term://", "^deol%-edit@" }

---無効なバッファか？
---@param bufnr number
---@return boolean
local is_valid_bufnr = function(bufnr)
	for _, re in ipairs(invalid_regex_list) do
		if vim.api.nvim_buf_get_name(bufnr):match(re) then
			return false
		end
	end
	return true
end

local gen_from_buffer_like_leaderf = function(opts)
	opts = opts or {}
	local default_icons, _ = devicons.get_icon("file", "", { default = true })

	local bufnrs = vim.tbl_filter(function(b)
		-- if ignore_current_buffer and (b == current_bufnr) then
		--   -- もし、カレントバッファだったらだめ
		--   return false
		-- end
		return vim.fn.buflisted(b) == 1 and is_valid_bufnr(b)
	end, vim.api.nvim_list_bufs())

	local bufnr_width = #tostring(math.max(unpack(bufnrs)))

	local max_bufname = math.max(unpack(vim.list_extend(
		{ strdisplaywidth("[No Name]") },
		vim.tbl_map(function(bufnr)
			return strdisplaywidth(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:t"))
		end, bufnrs)
	)))

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = bufnr_width },
			-- { width = 4 },
			{ width = 1 }, -- 同じプロジェクト内かどうか？
			-- { width = utils.strdisplaywidth(default_icons) },
			{ width = strdisplaywidth(default_icons) },
			{ width = max_bufname },
			{ remaining = true },
		},
	})

	-- local cwd = vim.fn.expand(opts.cwd or vim.fn.getcwd())

	-- リストの場合、ハイライトする
	local make_display = function(entry)
		return displayer({
			{ entry.bufnr, "TelescopeResultsNumber" },
			-- {entry.indicator, "TelescopeResultsComment"},
			entry.mark_in_same_project,
			-- {entry.mark_win_info, 'WarningMsg'},
			{ entry.devicons, entry.devicons_highlight },
			entry.file_name,
			{ entry.dir_name, "Comment" },
		})
	end

	local root_dir
	do
		local dir = vim.fn.expand("%:p:h")
		if dir == "" then
			dir = vim.fn.getcwd()
		end
		root_dir = find_git_ancestor(dir)
	end

	return function(entry)
		local bufname = entry.info.name ~= "" and entry.info.name or "[No Name]"

		-- local hidden = entry.info.hidden == 1 and 'h' or 'a'
		-- local readonly = vim.api.nvim_buf_get_option(entry.bufnr, 'readonly') and '=' or ' '
		-- local changed = entry.info.changed == 1 and '+' or ' '
		-- local indicator = entry.flag .. hidden .. readonly .. changed

		local dir_name = vim.fn.fnamemodify(bufname, ":p:h")
		local file_name = vim.fn.fnamemodify(bufname, ":p:t")

		local icons, highlight = devicons.get_icon(bufname, string.match(bufname, "%a+$"), {
			default = true,
		})

		-- プロジェクト内のファイルなら、印をつける
		-- 現在のバッファのプロジェクトを見つける
		local mark_in_same_project = ""
		if root_dir and root_dir ~= "" and vim.startswith(bufname, root_dir) then
			mark_in_same_project = "*"
		end

		-- -- もし、いずれかのウィンドウに表示されていたら、印をつける
		-- -- 󿩋󿫼󿫌󿨯󿧽󿥚󿦕󿥙󿠦󿟆󿝀󿔾
		-- local mark_win_info = ''
		-- local bufinfo = vim.fn.getbufinfo(entry.bufnr or 0)
		-- if entry.bufnr == vim.api.nvim_get_current_buf() then
		--   mark_win_info = '󿕅'
		-- elseif not vim.tbl_isempty(bufinfo) and not vim.tbl_isempty(bufinfo[1].windows) then
		--   mark_win_info = '󿠦'
		-- end

		return {
			valid = is_valid_bufnr(entry.bufnr),

			value = bufname,
			-- -- バッファ番号、ファイル名のみ、検索できるようにする
			-- ordinal = entry.bufnr .. " : " .. file_name,
			ordinal = file_name,
			display = make_display,

			bufnr = entry.bufnr,

			lnum = entry.info.lnum ~= 0 and entry.info.lnum or 1,
			-- indicator = indicator,
			devicons = icons,
			devicons_highlight = highlight,

			file_name = file_name,
			dir_name = dir_name,

			mark_in_same_project = mark_in_same_project,
			-- mark_win_info = mark_win_info,
		}
	end
end

-- @Summary buffers
-- @Description
return function()
	local ignore_current_buffer = false

	require("telescope.builtin").buffers({
		-- layout_strategy = 'vertical',
		shorten_path = false,
		show_all_buffers = true,
		ignore_current_buffer = ignore_current_buffer,
		sorter = conf.generic_sorter({}),
		-- previewer = previewers.cat.new({}),
		previewer = false,
		entry_maker = gen_from_buffer_like_leaderf(),

		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(smart_open(prompt_bufnr, "drop", "hide edit"))
			actions.select_horizontal:replace(smart_open(prompt_bufnr, "new", "new"))
			actions.select_vertical:replace(smart_open(prompt_bufnr, "vnew", "vnew"))
			actions.select_tab:replace(smart_open(prompt_bufnr, "tabedit", "tabedit"))

			local function delete_buffer()
				local selection = action_state.get_selected_entry()
				pcall(vim.cmd, string.format([[silent bdelete! %s]], selection.bufnr))

				-- TODO: refresh
			end

			map("n", "D", delete_buffer)

			return true
		end,
	})
end

