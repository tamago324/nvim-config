local lir = require("lir")
local utils = require('lir.utils')
local config = require('lir.config')
local Path = require("plenary.path")
local actions = require("lir.actions")

local function lcd(path)
	vim.cmd(string.format(":lcd %s", path))
end

local no_confirm_patterns = {
	"^LICENSE$",
	"^Makefile$",
	"^Dockerfile$",
	"^Procfile$",
}

local need_confirm = function(filename)
	for _, pattern in ipairs(no_confirm_patterns) do
		if filename:match(pattern) then
			return false
		end
	end
	return true
end

local function input_newfile()
	local save_curdir = vim.fn.getcwd()
	lcd(lir.get_context().dir)
	local name = vim.fn.input("New file: ", "", "file")
	lcd(save_curdir)

	if name == "" then
		return
	end

	if name == "." or name == ".." then
		utils.error("Invalid file name: " .. name)
		return
	end

	-- If I need to check, I will.
	if need_confirm(name) then
		-- '.' is not included or '/' is not included, then
		-- I may have entered it as a directory, I'll check.
		if not name:match("%.") and not name:match("/") then
			if vim.fn.confirm("Directory?", "&No\n&Yes", 1) == 2 then
				name = name .. "/"
			end
		end
	end

	local path = Path:new(lir.get_context().dir .. name)
	if string.match(name, "/$") then
		-- mkdir
		name = name:gsub("/$", "")
		path:mkdir({
			parents = true,
			mode = tonumber("700", 8),
			exists_ok = false,
		})
	else
		-- touch
		path:touch({
			parents = true,
			mode = tonumber("644", 8),
		})
	end

	-- If the first character is '.' and show_hidden_files is false, set it to true
	if name:match([[^%.]]) and not config.values.show_hidden_files then
		config.values.show_hidden_files = true
	end

	actions.reload()

	-- Jump to a line in the parent directory of the file you created.
	local lnum = lir.get_context():indexof(name:match("^[^/]+"))
	if lnum then
		vim.cmd(tostring(lnum))
	end
end

-- local lir = require("lir")
-- local utils = require("lir.utils")
-- local Path = require("plenary.path")
-- local config = require("lir.config")
-- local actions = require("lir.actions")
--
-- local input = require("xlir.nui.input").input
-- local confirm = require("xlir.nui.confirm").confirm
--
-- local Promise = require("promise")
-- local notify = require("xlir.notify")
--
-- -- local lcd = function(path)
-- --   vim.cmd(string.format([[silent execute (haslocaldir() ? 'lcd' : 'cd') '%s']], path))
-- -- end
--
-- local no_confirm_patterns = {
-- 	"^LICENSE$",
-- 	"^Makefile$",
-- 	"^Dockerfile$",
-- 	"^Procfile$",
-- }
--
-- local need_confirm = function(filename)
-- 	for _, pattern in ipairs(no_confirm_patterns) do
-- 		if filename:match(pattern) then
-- 			return false
-- 		end
-- 	end
-- 	return true
-- end
--
-- local function newfile()
-- 	local lir_dir = lir.get_context().dir
-- 	-- local save_curdir = vim.fn.getcwd()
-- 	-- lcd(lir.get_context().dir)
-- 	-- local name = vim.fn.input('New file: ', '', 'file')
-- 	-- lcd(save_curdir)
-- 	Promise.new(function(resolve)
-- 		input({
-- 			title = "New file",
-- 			border_color = "green",
-- 			on_submit = function(name)
-- 				resolve(name)
-- 			end,
-- 		})
-- 	end)
-- 		:next(function(name)
-- 			if name == "" then
-- 				-- 終了
-- 				return Promise.reject()
-- 			end
--
-- 			if name == "." or name == ".." then
-- 				utils.error("Invalid file name: " .. name)
-- 				-- 終了
-- 				return Promise.reject()
-- 			end
--
-- 			-- If I need to check, I will.
-- 			if need_confirm(name) then
-- 				-- '.' is not included or '/' is not included, then
-- 				-- I may have entered it as a directory, I'll check.
-- 				if not name:match("%.") and not name:match("/") then
-- 					-- promise を返すと、next でちゃんと処理してくれる
-- 					return Promise.new(function(resolve)
-- 						confirm({
-- 							title = "Directory?",
-- 							border_color = "yellow",
-- 							yes = function()
-- 								resolve(name .. "/")
-- 							end,
-- 							no = function()
-- 								resolve(name)
-- 							end,
-- 						})
-- 					end):next(function(v)
-- 						return v
-- 					end)
-- 				end
-- 			end
--
-- 			return name
-- 		end)
-- 		:next(function(name)
-- 			local path = Path:new(lir_dir .. name)
-- 			if string.match(name, "/$") then
-- 				-- mkdir
-- 				name = name:gsub("/$", "")
-- 				path:mkdir({
-- 					parents = true,
-- 					mode = tonumber("700", 8),
-- 					exists_ok = false,
-- 				})
-- 			else
-- 				-- touch
-- 				path:touch({
-- 					parents = true,
-- 					mode = tonumber("644", 8),
-- 				})
-- 			end
--
-- 			-- If the first character is '.' and show_hidden_files is false, set it to true
-- 			if name:match([[^%.]]) and not config.values.show_hidden_files then
-- 				config.values.show_hidden_files = true
-- 			end
--
-- 			notify("Create " .. name, vim.lsp.log_levels.INFO)
--
-- 			actions.reload()
--
-- 			-- Jump to a line in the parent directory of the file you created.
-- 			local lnum = lir.get_context():indexof(name:match("^[^/]+"))
-- 			if lnum then
-- 				vim.cmd(tostring(lnum))
-- 			end
-- 		end)
-- end

return input_newfile
