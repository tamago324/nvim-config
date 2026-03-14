local lir = require("lir")
local utils = require("lir.utils")
local actions = require("lir.actions")
local Path = require("plenary.path")

local Promise = require("promise")

local confirm = require("xlir.nui.confirm").confirm

local uv = vim.loop

local function esc_path(path)
	return vim.fn.shellescape(vim.fn.fnamemodify(path, ":p"), true)
end

local function delete()
	local ctx = lir.get_context()
	-- 選択されているものを取得する
	local marked_items = ctx:get_marked_items()
	if #marked_items == 0 then
		utils.error("Please mark one or more.")
		-- -- 選択されていなければ、カレント行を削除
		-- local path = ctx.dir .. ctx:current_value()
		-- vim.fn.system('gomi ' .. esc_path(path))
		-- actions.reload()
		return
	end

	-- for _, f in ipairs(marked_items) do
	--     -- TODO:
	--     -- 確認する
	--     -- "これ以降、同じ" みたいなこともしたい
	-- end

	-- if vim.fn.confirm('Delete files?', '&Yes\n&No', 2) ~= 1 then
	--   return
	-- end

	Promise.new(function(resolve)
		confirm({
			title = "Delete files?",
			border_color = "red",
			yes = function()
				resolve()
			end,
		})
	end):next(function()
		if vim.fn.executable("gomi") == 1 then
			local path_list = vim.tbl_map(function(items)
				return esc_path(items.fullpath)
			end, marked_items)
			vim.fn.system("gomi " .. vim.fn.join(path_list))
		else
			for _, item in ipairs(marked_items) do
				local path = Path:new(item.fullpath)
				if path:is_dir() then
					path:rm({ recursive = true })
				else
					if not uv.fs_unlink(path:absolute()) then
						utils.error("Delete file failed")
						return
					end
				end
			end
		end
		actions.reload()
	end)
end

return delete
