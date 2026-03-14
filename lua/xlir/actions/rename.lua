local Job = require("plenary.job")
local lir = require("lir")
local utils = require("lir.utils")
local actions = require("lir.actions")

local input = require("xlir.nui.input").input
local Promise = require("promise")

--- comamnd を実行する
---@param opts table
---@return any #err
---@return table #results
local command = function(opts)
	local results = {}
	local err = {}
	Job
		:new({
			command = opts.command,
			args = opts.args,
			cwd = opts.cwd or vim.fn.getcwd(),

			on_stdout = function(_, data)
				table.insert(results, data)
			end,

			on_stderr = function(_, data)
				table.insert(err, data)
			end,
		})
		:sync()

	if #err ~= 0 then
		return err, nil
	end
	return nil, results
end

---git root を返す
---@return string?
local get_git_root = function()
	local err, results = command({
		command = "git",
		args = { "rev-parse", "--show-toplevel" },
	})
	if err then
		return nil
	end

	return results[1]
end

--- git ls-files の結果を返す
---@param cwd string
---@return table #結果のリスト
local git_ls_files = function(cwd)
	local err, results = command({
		command = "git",
		args = { "ls-files" },
		cwd = cwd,
	})
	if err then
		return {}
	end

	return results
end

local git_mv = function(cwd, from, to)
	local err, results = command({
		command = "git",
		args = { "mv", from, to },
		cwd = cwd,
	})
end

local git_ls_files = function(cwd)
	local err, results = command({
		command = "git",
		args = { "ls-files" },
		cwd = cwd,
	})

	return results
end

local function rename()
	local ctx = lir.get_context()
	local old = string.gsub(ctx:current_value(), "/$", "")

	Promise.new(function(resolve)
		input({
			title = "Rename",
			border_color = "blue",
			default_value = old,
			on_submit = function(value)
				resolve(value)
			end,
		})
	end):next(function(new)
		if new == "" or new == old then
			return
		end

		if new == "." or new == ".." or string.match(new, "[/\\]") then
			utils.error("Invalid name: " .. new)
			return
		end

		-- もし、追跡されていたら、git mv を使う
		local git_root = get_git_root()

		local is_git_dir = false
		if git_root then
			is_git_dir = not vim.startswith(git_root, "fatal")
		end

		local is_git_file = false
		if is_git_dir then
			local files = git_ls_files(git_root)
			-- git root からの相対パス
			local rel_path = string.sub(ctx:current().fullpath, #git_root + 2)

			is_git_file = vim.tbl_contains(files, rel_path)
		end

		if not is_git_dir then
			if not vim.loop.fs_rename(ctx.dir .. old, ctx.dir .. new) then
				utils.error("Rename failed")
			end
		else
			-- git root からの相対パス
			local rel_path = string.sub(ctx:current().fullpath, #git_root + 2)

			local files = git_ls_files(git_root)

			if vim.tbl_contains(files, rel_path) then
				-- 管理対象に入っていたら、 git mv で移動
				git_mv(ctx.dir, old, new)
			else
				if not vim.loop.fs_rename(ctx.dir .. old, ctx.dir .. new) then
					utils.error("Rename failed")
				end
			end
		end

		actions.reload()

		-- ジャンプ
		local lnum = lir.get_context():indexof(new)
		if lnum then
			vim.cmd(tostring(lnum))
		end
	end)
end

return rename
