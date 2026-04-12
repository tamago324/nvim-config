if vim.api.nvim_call_function("FindPlugin", { "sshfs.nvim" }) == 0 then
	do
		return
	end
end

require("sshfs").setup({
	hooks = {
		on_exit = {
			auto_unmount = true, -- auto-disconnect all mounts on :q or exit
			clean_mount_folders = true, -- optionally clean up mount folders after disconnect
		},
		on_mount = {
			auto_change_to_dir = true, -- auto-change current directory to mount point
			-- auto_run = "find",          -- "find" (default), "grep", "live_find", "live_grep", "terminal", "none", or a custom function(ctx)
			auto_run = "none",
		},
	},

	-- connections = {
	-- 	sshfs_options = {
	-- 		sftp_server = "sudo -n /usr/lib/openssh/sftp-server",
	-- 	},
	-- },
})
