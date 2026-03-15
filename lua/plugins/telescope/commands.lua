local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local ext_utils = require("plugins/telescope/utils")

local get_fzy_sorter_use_list = ext_utils.get_fzy_sorter_use_list

-- @Summary リストを反転する
-- @Description リストを反転する
-- @Param  t リスト
local reverse = function(t)
	local n = #t
	for i = 1, n / 2 do
		t[i], t[n] = t[n], t[i]
		n = n - 1
	end
	return t
end

local function make_def_func(is_xmap)
	return function(prompt_bufnr, _)
		local entry = action_state.get_selected_entry()
		actions.close(prompt_bufnr)
		local val = entry.value
		local cmd = string.format([[%s%s ]], (is_xmap and "'<,'>" or ""), val.name)

		if val.nargs == "0" or val.nargs == "*" or val.nargs == "?" then
			if is_xmap then
				local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
				vim.api.nvim_feedkeys(":" .. cmd .. cr, "n", true)
			else
				vim.fn.histadd("cmd", cmd)
				vim.cmd(cmd)
			end
		else
			vim.cmd([[stopinsert]])
			vim.fn.feedkeys(":" .. cmd)
		end
	end
end

local function make_edit_command_func(is_xmap)
	return function(prompt_bufnr)
		local entry = action_state.get_selected_entry()
		actions.close(prompt_bufnr)
		local val = entry.value
		local cmd = string.format([[:%s%s ]], (is_xmap and "'<,'>" or ""), val.name)

		vim.cmd([[stopinsert]])
		vim.fn.feedkeys(cmd)
	end
end

-- @Summary commands の Sorter を生成
-- @Description 履歴をもとにして、ソートする Sorter を生成して返す
local function get_commands_sorter()
	local list = {}
	-- :history cmd で取れるやつを取得する
	local history_string = vim.fn.execute("history cmd")
	local history_list = reverse(vim.split(history_string, "\n"))
	for _, line in ipairs(history_list) do
		--                  ^\>?\s+\d+\s+([^ !]+)
		local cmd = line:match("^>?%s+%d+%s+([^ !]+)")
		if cmd then
			table.insert(list, cmd)
		end
	end

	return get_fzy_sorter_use_list({
		list = list,
	})
end

-- commands
return function()
	local n_commands = function()
		require("telescope.builtin").commands({
			sorter = get_commands_sorter(),
			attach_mappings = function(_, map)
				actions.select_default:replace(make_def_func())

				map("i", "<C-e>", make_edit_command_func())

				return true
			end,
		})
	end

	local x_commands = function()
		require("telescope.builtin").commands({
			sorter = get_commands_sorter(),
			attach_mappings = function(_, map)
				actions.select_default:replace(make_def_func(true))
				map("i", "<C-e>", make_edit_command_func(true))
				return true
			end,

			entry_maker = function(line)
				return {
					-- 範囲指定ができるもののみ
					valid = line ~= "" and line.range,
					value = line,
					ordinal = line.name,
					display = line.name,
				}
			end,
		})
	end

	return n_commands, x_commands
end

