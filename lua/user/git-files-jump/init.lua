local Job = require("plenary.job")
local gitsigns = require('gitsigns')

---@class GitFilesJumpFileItem
---@field relative_path string
---@field full_path string

-- state の管理
-- その key ごとに files が存在する
---@class GitFilesJumpStateItem
---@field files GitFilesJumpFileItem[]

-- key は git_root となる
---@type table<string, GitFilesJumpStateItem>
local state = {}

local function command(opts)
	local results = {}
	local err = {}

	Job:new({
		command = opts.command,
		args = opts.args,
		cwd = opts.cwd or vim.fn.getcwd(),
		on_stdout = function(_, data)
			if data ~= nil and data ~= "" then
				table.insert(results, data)
			end
		end,
		on_stderr = function(_, data)
			if data ~= nil and data ~= "" then
				table.insert(err, data)
			end
		end,
	}):sync()

	if #err ~= 0 then
		return err, nil
	end

	return nil, results
end

local function get_git_root()
	local err, results = command({
		command = "git",
		args = { "rev-parse", "--show-toplevel" },
	})
	if err then
		return nil
	end

	if results == nil then
		return nil
	end

	return results[1]
end

local function get_state_item(git_root)
	state[git_root] = state[git_root] or {}
	return state[git_root]
end

local function get_full_path(git_root, relative_path)
	return git_root .. "/" .. relative_path
end

local function get_modified_files(cwd)
	local err, results = command({
		command = "git",
		args = { "ls-files", "--modified", "--others", "--exclude-standard" },
		cwd = cwd,
	})
	if err then
		return {}
	end

	if results == nil then
		return {}
	end

	local files = {}
	for _, relative_path in ipairs(results) do
		table.insert(files, {
			relative_path = relative_path,
			full_path = get_full_path(cwd, relative_path),
		})
	end

	return files
end

local function load_files(git_root)
	local item = get_state_item(git_root)
	if item.files == nil then
		item.files = get_modified_files(git_root)
	end

	return item.files
end

local function refresh(git_root)
	if git_root == nil then
		git_root = get_git_root()
	end
	if git_root == nil then
		return
	end

	get_state_item(git_root).files = get_modified_files(git_root)

	vim.notify(string.format("Refresh! (%d files)", #(get_state_item(git_root).files or {})))
end

local function get_relative_path(current_file, git_root)
	if git_root ~= nil and current_file:sub(1, #git_root + 1) == git_root .. "/" then
		return current_file:sub(#git_root + 2)
	end

	return vim.fn.fnamemodify(current_file, ":.")
end

local function get_current_file()
	local current_file = vim.fn.expand("%:p")
	if current_file == "" then
		return nil
	end

	return current_file
end

local function get_index_by_current_file(current_file, files, git_root)
	local current_rel = get_relative_path(current_file, git_root)

	for i, file in ipairs(files) do
		if file.relative_path == current_rel then
			return i
		end
	end

	return nil
end

local function get_target_index(current_index, direction, file_count)
	if current_index == nil then
		return 1
	end

	if direction == "prev" then
		local target_index = current_index - 1
		if target_index < 1 then
			target_index = file_count
		end
		return target_index
	end

	local target_index = current_index + 1
	if target_index > file_count then
		target_index = 1
	end
	return target_index
end

local function ensure_files(git_root)
	local files = load_files(git_root)
	if #files == 0 then
		refresh(git_root)
		files = get_state_item(git_root).files or {}
	end

	return files
end

local function open_file(path)
	vim.cmd.edit(vim.fn.fnameescape(path))
end

local function notify_jump(target_index, files)
	vim.notify(string.format("(%d of %d): %s", target_index, #files, files[target_index].relative_path))
end

local function open_and_jump_first_hunk(path, files, target_index)
	open_file(path)
	gitsigns.nav_hunk('first', { navigation_message = false })
	vim.cmd('NeoscrollDisableBufferPM')
	vim.cmd('normal zz')
	vim.cmd('NeoscrollEnableBufferPM')
	notify_jump(target_index, files)
end


local function jump(direction)
	local current_file = get_current_file()
	if current_file == nil then
		return
	end

	local git_root = get_git_root()
	if git_root == nil then
		vim.notify("Git リポジトリではありません", vim.log.levels.WARN)
		return
	end

	local files = ensure_files(git_root)
	if #files == 0 then
		return
	end

	local current_index = get_index_by_current_file(current_file, files, git_root)
	local target_index = get_target_index(current_index, direction, #files)

	open_and_jump_first_hunk(files[target_index].full_path, files, target_index)
end

local function stage_current_file(current_file, git_root)
	local current_rel = get_relative_path(current_file, git_root)

	local err = command({
		command = "git",
		args = { "-C", git_root, "add", "--", current_rel },
	})
	if err ~= nil then
		return nil
	end

	return current_rel
end

local function stage()
	local current_file = get_current_file()
	if current_file == nil then
		return
	end

	local git_root = get_git_root()
	if git_root == nil then
		return
	end

	if stage_current_file(current_file, git_root) == nil then
		return
	end

	refresh(git_root)
end

local function get_next_relative_path(current_file, git_root, files)
	if #files == 0 then
		return nil
	end

	local current_index = get_index_by_current_file(current_file, files, git_root)
	local target_index = get_target_index(current_index, "next", #files)

	return files[target_index].relative_path, target_index
end

local function stage_and_next()
	local current_file = get_current_file()
	if current_file == nil then
		return
	end

	local git_root = get_git_root()
	if git_root == nil then
		return
	end

	local files = ensure_files(git_root)
	local target_rel, target_index = get_next_relative_path(current_file, git_root, files)

	if stage_current_file(current_file, git_root) == nil then
		return
	end

	refresh(git_root)

	if target_rel ~= nil then
		-- vim.notify(string.format("%s", target_rel))
		open_and_jump_first_hunk(get_full_path(git_root, target_rel), files, target_index)
	end
end

local commands = {
	refresh = refresh,
	jump_next = function()
		jump("next")
	end,
	jump_prev = function()
		jump("prev")
	end,
	stage = stage,
	stage_and_next = stage_and_next,
}

vim.keymap.set("n", "gj", commands.jump_next, { desc = "GitFileJump: next file" })
vim.keymap.set("n", "gk", commands.jump_prev, { desc = "GitFileJump: prev file" })
vim.keymap.set("n", "gr", commands.refresh, { desc = "GitFileJump: refresh" })
vim.keymap.set("n", "gss", commands.stage, { desc = "GitFileJump: stage file" })
vim.keymap.set("n", "gsn", commands.stage_and_next, { desc = "GitFileJump: stage file and jump next" })
