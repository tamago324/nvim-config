-- lir のプレビュー
-- lir の float window に合わせて、表示してあげる
local a = vim.api
local lir = require("lir")

local Promise = require("promise")
local Path = require("plenary.path")
local filetype = require("plenary.filetype")

local putils = require("telescope.previewers.utils")

local M = {}

local float_bufnr = nil
local float_win = nil
local preview_enable = false

local function setup_autocmd(bufnr, win_id)
	vim.cmd(
		string.format(
			"autocmd WinClosed,BufLeave,BufDelete <buffer=%s> ++nested ++once :lua require('xlir.float_preview').close()",
			bufnr
		)
	)
	vim.cmd(string.format("autocmd CursorMoved <buffer=%s> :lua pcall(require('xlir.float_preview').setlines)", bufnr))
end

local function split(s, sep, plain, opts)
	opts = opts or {}
	local t = {}
	for c in vim.gsplit(s, sep, plain) do
		table.insert(t, c)
		if opts.timeout then
			local diff_time = (vim.loop.hrtime() - opts.start_time) / 1e6
			if diff_time > opts.timeout then
				return t
			end
		end
	end
	return t
end

local function read_file_setlines(filepath, bufnr)
	local opts = {}
	opts.start_time = vim.loop.hrtime()
	opts.timeout = 100

	Promise.new(function(resolve)
		Path:new(filepath):_read_async(function(data)
			resolve(filepath, data)
		end)
	end):next(vim.schedule_wrap(function(path, data)
		local processed_data = split(data, "[\r]?\n", false, opts)

		if processed_data then
			a.nvim_buf_set_lines(bufnr, 0, -1, false, processed_data)
			-- local ok = pcall()
			-- if not ok then
			--   return Promise.reject()
			-- end

			-- treesitter を使って、ハイライトする
			local ft = filetype.detect_from_extension(path)
			if not putils.ts_highlighter(bufnr, ft) then
				-- もし、treesitterに対応していないなら、 syntax を ON にする
				vim.api.nvim_buf_set_option(bufnr, "syntax", ft)
			end
		end
	end))
end

function M.preview_toggle()
	preview_enable = not preview_enable

	M.preview()
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

	local lnum = vim.fn.getpos(".")

	local filepath
	local is_dir
	if lir_ctx:current() then
		filepath = lir_ctx:current().fullpath
		is_dir = lir_ctx:current().is_dir
	end

	local lir_win = a.nvim_get_current_win()
	local lir_bufnr = a.nvim_win_get_buf(0)

	local opts = a.nvim_win_get_config(0)
	float_bufnr = a.nvim_create_buf(false, true)

	local half = math.floor(opts.width / 2)

	local win_opts = {
		col = opts.col[false] + half,
		row = opts.row[false] + 1,
		width = half,
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

	float_win = a.nvim_open_win(float_bufnr, true, win_opts)
	a.nvim_win_set_option(float_win, "cursorline", false)
	a.nvim_win_set_option(float_win, "cursorcolumn", false)
	a.nvim_win_set_option(float_win, "wrap", false)
	a.nvim_win_set_option(float_win, "signcolumn", "no")
	a.nvim_win_set_option(float_win, "foldlevel", 50)

	-- ハイライトを設定
	vim.cmd([[setlocal winhl=Normal:LirFloatNormal,EndOfBuffer:LirFloatNormal]])

	setup_autocmd(lir_bufnr, float_win)
	a.nvim_set_current_win(lir_win)

	-- 行をセット
	M.setlines(filepath)
end

function M.setlines(filepath)
	if not a.nvim_win_is_valid(float_win) then
		M.preview()
		return
	end
	-- パスが渡されたら、それを使って、渡されなかったら、 lir から取得する
	filepath = vim.F.if_nil(filepath, lir.get_context():current().fullpath)

	-- ディレクトリなら、終わり
	if lir.get_context():current().is_dir then
		a.nvim_buf_set_lines(float_bufnr, 0, -1, false, { "" })
		-- a.nvim_buf_set_option(bufnr, "filetype", 'lir')
		return
	end

	read_file_setlines(filepath, float_bufnr)
end

function M.close()
	pcall(vim.api.nvim_win_close, float_win, true)
end

function _G._LirFloatPreviewSetupAutocmd()
	if not float_win then
		return
	end
	setup_autocmd(vim.fn.bufnr(), float_win)
end

vim.cmd([[augroup lir-float-preview]])
vim.cmd([[  autocmd!]])
vim.cmd([[  autocmd FileType lir :lua _LirFloatPreviewSetupAutocmd()]])
vim.cmd([[augroup END]])

return M
