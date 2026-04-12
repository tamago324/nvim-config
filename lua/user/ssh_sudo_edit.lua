if vim.api.nvim_call_function("FindPlugin", { "sshfs.nvim" }) == 0 then
	do
		return
	end
end

local sshfs = require("sshfs")

local M = {}

local function notify(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "SshSudoEdit" })
end

local function normalize_remote_path(conn, path)
	local mount_path = conn.mount_path:gsub("/+$", "")
	local remote_root = conn.remote_path or "/"
	remote_root = remote_root:gsub("/+$", "")
	if remote_root == "" then
		remote_root = "/"
	end

	if path == mount_path then
		return remote_root
	end

	if path:sub(1, #mount_path + 1) == mount_path .. "/" then
		local relative = path:sub(#mount_path + 2)
		if remote_root == "/" then
			return "/" .. relative
		end

		return remote_root .. "/" .. relative
	end

	return path
end

local function get_current_file()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		notify("Current buffer has no file path", vim.log.levels.WARN)
		return nil
	end

	return file
end

local function is_under_mount_path(conn, path)
	local mount_path = conn.mount_path:gsub("/+$", "")
	return path == mount_path or path:sub(1, #mount_path + 1) == mount_path .. "/"
end

local function resolve_target_and_file(opts)
	local conn = sshfs.get_active()
	local arg_count = #opts.fargs

	if arg_count >= 2 then
		return opts.fargs[1], opts.fargs[2]
	end

	if conn == nil then
		notify("No active sshfs connection", vim.log.levels.ERROR)
		return nil, nil
	end

	local target = conn.host or conn.mount_name
	if arg_count == 1 then
		return target, opts.fargs[1]
	end

	local file = get_current_file()
	if file == nil then
		return nil, nil
	end

	if not is_under_mount_path(conn, file) then
		notify("Current file is not inside the active sshfs mount", vim.log.levels.ERROR)
		return nil, nil
	end

	return target, normalize_remote_path(conn, file)
end

local function open_wezterm_tab(target, file)
	if vim.fn.executable("wezterm.exe") ~= 1 then
		notify("wezterm is not available in PATH", vim.log.levels.ERROR)
		return
	end

	if vim.fn.executable("ssh") ~= 1 then
		notify("ssh is not available in PATH", vim.log.levels.ERROR)
		return
	end

	local command = {
		"wezterm.exe",
		"cli",
		"spawn",
		"--",
		"ssh",
		"-t",
		target,
		string.format([[/opt/nvim/nvim -c "SudaRead %s"]], file),
	}

	local job_id = vim.fn.jobstart(command, { detach = true })
	if job_id <= 0 then
		notify("Failed to launch WezTerm", vim.log.levels.ERROR)
		return
	end

	notify(string.format("Opened %s on %s", file, target))
end

M.setup = function()
	vim.api.nvim_create_user_command("SshSudoEdit", function(opts)
		local target, file = resolve_target_and_file(opts)
		if target == nil or file == nil then
			return
		end

		open_wezterm_tab(target, file)
	end, {
		nargs = "*",
		desc = "Open remote sudoedit in a new WezTerm tab",
	})
end

M.setup()

return M
