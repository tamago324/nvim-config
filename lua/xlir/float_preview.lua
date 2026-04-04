-- lir float preview
-- lir の float window に合わせて、表示する
local a = vim.api
local lir = require("lir")
local config = require("lir.config")
local devicons = require("lir.devicons")
local highlight = require("lir.highlight")
local uv = vim.loop

local Promise = require("promise")
local Path = require("plenary.path")
local filetype = require("plenary.filetype")

local M = {}

local float_preview_bufnr = nil
local float_preview_win = nil
local preview_enable = false

local ns_float_preview = a.nvim_create_namespace('LirFloatPreview')

local nvim011 = vim.fn.has("nvim-0.11") == 1
local has_ts_parser = (nvim011 and vim.treesitter.language.add)
		or function(lang)
			return pcall(vim.treesitter.language.add, lang)
		end

local ts_highlight_on = function(bufnr, path)
	-- treesitter を使って、ハイライトする
	local ft = filetype.detect_from_extension(path)

	if ft and ft ~= "" then
		local lang = vim.treesitter.language.get_lang(ft) or ft
		if lang and has_ts_parser(lang) then
			return vim.treesitter.start(bufnr, lang)
		end
	else
		-- もし、treesitterに対応していないなら、 syntax を ON にする
		vim.api.nvim_buf_set_option(bufnr, "syntax", ft)
	end
end

local is_binary = function(filepath)
	local fd = uv.fs_open(filepath, "r", 438)
	if not fd then
		return true
	end
	local chunk = uv.fs_read(fd, 1024, 0)
	uv.fs_close(fd)
	if chunk and chunk:find("\0", 1, true) then
		return true
	end

	return false
end

local function put_preview_hl_text(bufnr, text, hl)
	a.nvim_buf_set_lines(bufnr, 0, -1, false, { text })
	vim.hl.range(bufnr, ns_float_preview, hl, { 1, 1 }, { 1, #text })
end


local preview_skip_extensions = { 'pdf' }
local function skip_preview(filepath)
	local ext = vim.fn.fnamemodify(filepath, ':e')
	if vim.tbl_contains(preview_skip_extensions, ext) then
		return true
	end
end

local function read_file_setlines(filepath, bufnr)
	-- バイナリはプレビューを表示しない
	local stat = uv.fs_stat(filepath)
	if not stat or stat.type ~= "file" or is_binary(filepath) then
		put_preview_hl_text(bufnr, "	@@@ This is binary file @@@", 'LirFloatPreviewBinary')
		return
	end

	-- プレビューをスキップ
	if skip_preview(filepath) then
		put_preview_hl_text(bufnr, '	@@@ Skip preview @@@', 'LirFloatPreviewBinary')
		return
	end

	-- 高さ分だけ読み取る
	local height = 0
	if float_preview_win and a.nvim_win_is_valid(float_preview_win) then
		height = a.nvim_win_get_height(float_preview_win)
	end

	Promise.new(function(resolve)
		local data = vim.fn.readfile(filepath, "", height > 0 and height or -1)
		---@diagnostic disable-next-line: redundant-parameter
		resolve(filepath, data)
	end):next(vim.schedule_wrap(function(path, data)
		if data and #data > 0 then
			a.nvim_buf_set_lines(bufnr, 0, -1, false, data)
			ts_highlight_on(bufnr, path)
		else
			-- 空なら、クリアする
			a.nvim_buf_set_lines(bufnr, 0, -1, false, {})
		end
	end))
end

-- from lir.lua
local function readdir(path)
	local files = {}
	local handle = uv.fs_scandir(path)
	if handle == nil then
		return {}
	end

	while true do
		local name, _ = uv.fs_scandir_next(handle)
		if name == nil then
			break
		end
		local p = Path:new(path):joinpath(name)
		local is_dir = p:is_dir()
		local file = {
			value = name,
			is_dir = is_dir,
			fullpath = p:absolute(),
			display = nil,
			devicons = nil,
		}

		local prefix = config.values.hide_cursor and "" or " "

		if config.values.devicons and config.values.devicons.enable then
			local icon, highlight_name = devicons.get_devicons(name, is_dir)
			file.display = string.format("%s%s %s%s", prefix, icon, name, (is_dir and "/" or ""))
			file.devicons = { icon = icon, highlight_name = highlight_name }
		else
			file.display = prefix .. name .. (is_dir and "/" or "")
		end

		table.insert(files, file)
	end
	return files
end

local function sort(lhs, rhs)
	if lhs.is_dir and not rhs.is_dir then
		return true
	elseif not lhs.is_dir and rhs.is_dir then
		return false
	end
	return lhs.value < rhs.value
end

function M.preview()
	if not preview_enable then
		return M.close()
	end

	if vim.bo.ft ~= "lir" then
		return
	end

	local lir_ctx = lir.get_context()
	if #lir_ctx.files == 0 then
		return
	end

	local filepath
	if lir_ctx:current() then
		filepath = lir_ctx:current().fullpath
	end

	local lir_win = a.nvim_get_current_win()

	local opts = a.nvim_win_get_config(0)
	float_preview_bufnr = a.nvim_create_buf(false, true)

	local preview_width = math.floor(opts.width * 0.6)
	local win_opts = {
		col = opts.col + (opts.width - preview_width),
		row = opts.row + 1,
		width = preview_width,
		height = opts.height,
		focusable = false,
		anchor = "NW",
		border = {
			{ "", "" },
			{ "", "" },
			{ "", "" },
			{ "", "" },
			{ "", "" },
			{ "", "" },
			{ "", "" },
			{ "│", "Normal" },
		},
		relative = "editor",
		zindex = opts.zindex + 10,
	}

	float_preview_win = a.nvim_open_win(float_preview_bufnr, false, win_opts)
	a.nvim_win_set_option(float_preview_win, "cursorline", false)
	a.nvim_win_set_option(float_preview_win, "cursorcolumn", false)
	a.nvim_win_set_option(float_preview_win, "wrap", false)
	a.nvim_win_set_option(float_preview_win, "signcolumn", "no")
	a.nvim_win_set_option(float_preview_win, "foldlevel", 50)

	vim.fn.win_execute(float_preview_win, [[setlocal winhl=Normal:LirFloatNormal,EndOfBuffer:LirFloatNormal]], true)

	a.nvim_set_current_win(lir_win)

	M.setlines(filepath)
end

function M.setlines(filepath)
	if not a.nvim_win_is_valid(float_preview_win) then
		M.preview()
		return
	end
	-- autocmd で取得する
	filepath = vim.F.if_nil(filepath, lir.get_context():current().fullpath)

	-- ディレクトリなら、そのディレクトリ内の内容を表示
	-- 本当は、edit でやりたかったけど、なんかうまくいかないから、いったんは独自実装
	if lir.get_context():current().is_dir then
		local files = readdir(filepath)
		if #files == 0 then
			put_preview_hl_text(float_preview_bufnr, "	Directory is empty", 'LirEmptyDirText')
			return
		end

		if not config.values.show_hidden_files then
			files = vim.tbl_filter(function(val)
				return string.match(val.value, "^[^.]") ~= nil
			end, files)
		end

		files = vim.tbl_filter(function(val)
			return not vim.tbl_contains(config.values.ignore, val.value)
		end, files)

		table.sort(files, sort)
		a.nvim_buf_set_lines(
			float_preview_bufnr,
			0,
			-1,
			false,
			vim.tbl_map(function(item)
				return item.display
			end, files)
		)
		a.nvim_win_call(float_preview_win, function()
			highlight.update_highlight(files)
			-- treesiter はOFF
			vim.treesitter.stop()
		end)

		vim.api.nvim_buf_set_option(float_preview_bufnr, "syntax", "off")
		return
	end

	read_file_setlines(filepath, float_preview_bufnr)
end

function M.close()
	pcall(vim.api.nvim_win_close, float_preview_win, true)
end

vim.api.nvim_create_augroup("lir-float-preview", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "lir-float-preview",
	pattern = "lir",
	callback = function(args)
		local bufnr = args.buf
		local group = vim.api.nvim_create_augroup("lir-float-preview-buffer-" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd({ "WinClosed", "BufLeave", "BufDelete" }, {
			group = group,
			buffer = bufnr,
			nested = true,
			once = true,
			callback = function()
				require("xlir.float_preview").close()
			end,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = group,
			buffer = bufnr,
			callback = function()
				pcall(require("xlir.float_preview").setlines)
			end,
		})
	end,
})

-- public functions
function M.toggle()
	preview_enable = not preview_enable
	M.preview()
end

function M.on()
	preview_enable = true
	M.preview()
end

function M.off()
	preview_enable = false
	M.close()
end

return M
