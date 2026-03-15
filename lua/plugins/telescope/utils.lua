local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local sorters = require("telescope.sorters")

local M = {}

--- 選択しているときとしていないときの両方でひらけるようにした
---
---@param prompt_bufnr number
---@param first_open_cmd string 最初のアイテムを開くコマンド
---@param other_open_cmd string 2つ目以降のアイテムを開くコマンド
---@return function
M.smart_open = function(prompt_bufnr, first_open_cmd, other_open_cmd)
	first_open_cmd = first_open_cmd or "drop"
	other_open_cmd = other_open_cmd or first_open_cmd

	return function()
		local current_picker = action_state.get_current_picker(prompt_bufnr)
		local selections = current_picker:get_multi_selection()
		actions.close(prompt_bufnr)

		-- もし、HOME にいたら、そのディレクトリの git root に移動する
		if vim.fn.getcwd() == vim.fn.expand("$HOME") then
			local item = action_state.get_selected_entry().value
			vim.cmd("lcd" .. vim.fn.fnamemodify(item, ":h"))
		end

		if not next(selections) then
			-- 選択してなかったら、カーソル下のアイテムを開く
			local val = action_state.get_selected_entry().value
			vim.api.nvim_command(string.format("%s %s", first_open_cmd, val))
		else
			for i, selection in ipairs(selections) do
				local cmd = (i == 1 and first_open_cmd) or other_open_cmd
				local val = selection.value
				vim.api.nvim_command(string.format("%s %s", cmd, val))
			end
		end
	end
end

-- Sorter using the fzy algorithm
local find = function(needle, haystack)
	for i = 1, #haystack do
		if needle == haystack[i] then
			return i
		end
	end
	-- 見つからなかったら、最悪なスコアを返す
	return #haystack
end

-- telescope の sorters.get_fzy_sorter() をもとに作成
--@Summary なにかしらのリストを使って、ソートをいい感じにする
--@Description MRUなどのリストを渡す (1が高スコア、#listが低スコア)
--@Param  opts
--    opts.list ファイルのリスト (entry.ordinal と一致する要素を含むリスト)
--    opts.get_needle  entry から needle となる値を取得する関数
M.get_fzy_sorter_use_list = function(opts)
	vim.validate({
		opts = { opts, "table", false },
	})
	vim.validate({
		["opts.list"] = { opts.list, "table", false },
		["opts.get_needle"] = { opts.get_needle, "function", true },
	})
	local list = opts.list
	local get_needle = opts.get_needle or function(v)
		return v.ordinal
	end

	local fzy = require("telescope.algos.fzy")
	-- すべての文字列 prompt, line において、
	--  fzy.get_score_min() ～ fzy.get_score_max() の間になく、
	--  fzy.has_match(prompt, line) == true のとき
	-- fzy.score(prompt, line) > fzy.get_score_floor() が true になる
	local OFFSET = -fzy.get_score_floor() -- (1024 + 1) * -0.01 = -10.25

	-- 0 が最高、1 が最悪、-1はマッチしなかった
	return sorters.Sorter:new({
		discard = true,

		-- line == ordinal
		scoring_function = function(_, prompt, line, entry)
			-- まず、マッチするかをチェックする
			if not fzy.has_match(prompt, line) then
				return -1
			end

			local fzy_score = fzy.score(prompt, line)

			-- 空クエリか、長過ぎる文字列は fzy を -inf (fzy.get_score_min()) になるため、
			-- 最悪のスコアである 1 を返す
			-- また、この関数は、0 ~ 1 の間のスコアを返す
			if fzy_score == fzy.get_score_min() then
				return 1 + #list
			end

			-- Poor non-empty matches can also have negative values. Offset the score
			-- so that all values are positive, then invert to match the
			-- telescope.Sorter "smaller is better" convention. Note that for exact
			-- matches, fzy returns +inf, which when inverted becomes 0.
			-- リストの先頭が最高のスコアになるように足し込む (小さい方が高スコアだから)
			-- pprint(find(get_needle(entry), list))
			return (1 / (fzy_score + OFFSET)) + find(get_needle(entry), list)
		end,

		-- The fzy.positions function, which returns an array of string indices, is
		-- compatible with telescope's conventions. It's moderately wasteful to
		-- call call fzy.score(x,y) followed by fzy.positions(x,y): both call the
		-- fzy.compute function, which does all the work. But, this doesn't affect
		-- perceived performance.
		highlighter = function(_, prompt, display)
			return fzy.positions(prompt, display)
		end,
	})
end

return M

