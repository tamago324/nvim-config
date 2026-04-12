if vim.api.nvim_call_function("FindPlugin", { "remote-sshfs.nvim" }) == 0 then
	do
		return
	end
end

require("remote-sshfs").setup()

require("telescope").load_extension("remote-sshfs")
