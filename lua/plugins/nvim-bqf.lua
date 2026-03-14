if vim.api.nvim_call_function("FindPlugin", { "nvim-bqf" }) == 0 then
	do
		return
	end
end

require("bqf").setup({
	preview = {
		border_chars = { "│", "│", "─", "─", "+", "+", "+", "+", "█" },
		win_height = 30,
	},
	auto_resize_height = true,
	func_map = {
		tab = "<C-t>",
		lastleave = "<C-o>",
		prevfile = "<Up>",
		nextfile = "<Down>",
		openc = "<CR>",
		-- 上書きしないとだめ
		open = "",
	},
})

local fn = vim.fn

-- quickfixtextfunc で設定する
function _G.qftf(info)
	local items
	local ret = {}
	-- type を取れる
	if info.quickfix == 1 then
		items = fn.getqflist({ id = info.id, items = 0 }).items
	else
		items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
	end

	local limit = 31
	local fname_fmt1 = "%-" .. limit .. "s"
	local fname_fmt2 = "…%." .. (limit - 1) .. "s"

	local valid_fmt = "%s │%5d:%-3d│%s %s"

	for i = info.start_idx, info.end_idx do
		local e = items[i]
		local fname = ""
		local str
		if e.valid == 1 then
			if e.bufnr > 0 then
				fname = fn.bufname(e.bufnr)
				if fname == "" then
					fname = "[No Name]"
				else
					fname = fname:gsub("^" .. vim.env.HOME, "~")
				end
				-- char in fname may occur more than 1 width, ignore this issue in order to keep performance
				if #fname <= limit then
					fname = fname_fmt1:format(fname)
				else
					fname = fname_fmt2:format(fname:sub(1 - limit))
				end
			end
			local lnum = e.lnum > 99999 and -1 or e.lnum
			local col = e.col > 999 and -1 or e.col
			local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
			str = valid_fmt:format(fname, lnum, col, qtype, e.text)
		else
			str = e.text
		end
		table.insert(ret, str)
	end
	return ret
end

vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
