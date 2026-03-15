local M = {}

--- Jumps to a location.
---
---@param location table (`Location`|`LocationLink`)
---@param offset_encoding string utf-8|utf-16|utf-32 (required)
---@returns `true` if the jump succeeded
function M.jump_to_location(location, offset_encoding)
	-- location may be Location or LocationLink
	local uri = location.uri or location.targetUri
	if uri == nil then
		return
	end
	if offset_encoding == nil then
		vim.notify_once("jump_to_location must be called with valid offset encoding", vim.log.levels.WARN)
	end
	local bufnr = vim.uri_to_bufnr(uri)
	-- Save position in jumplist
	vim.cmd("normal! m'")

	-- Push a new item into tagstack
	local from = { vim.fn.bufnr("%"), vim.fn.line("."), vim.fn.col("."), 0 }
	local items = { { tagname = vim.fn.expand("<cword>"), from = from } }
	vim.fn.settagstack(vim.fn.win_getid(), { items = items }, "t")

	-- 現在のバッファかどうかによって、searchx#cursor#goto を使うかどうかを決める
	local cur_bufnr = vim.api.nvim_get_current_buf()

	--- Jump to new location (adjusting for UTF-16 encoding of characters)
	vim.api.nvim_set_current_buf(bufnr)
	vim.api.nvim_buf_set_option(bufnr, "buflisted", true)
	local range = location.range or location.targetSelectionRange
	local row = range.start.line
	local col = vim.lsp.util._get_line_byte_from_position(bufnr, range.start, offset_encoding)
	if cur_bufnr == bufnr then
		vim.fn["searchx#cursor#goto"]({ row + 1, col + 1 })
	else
		vim.fn.cursor(row + 1, col + 1)
		-- カーソル位置を pulse
		vim.fn["search_pulse#Pulse"](true)
	end
	-- Open folds under the cursor
	vim.cmd("normal! zv")
	return true
end

M.moved_pulse = function(cb)
	-- ウィンドウの表示範囲が上に行ったら、ハイライトする
	local firstline = vim.fn.line("w0")

	cb()

	if vim.fn.line("w0") < firstline then
		vim.fn["search_pulse#Pulse"]()
	end
end

return M
