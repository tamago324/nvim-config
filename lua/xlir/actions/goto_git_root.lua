return function()
	local dir = vim.fs.dirname(vim.fs.find(".git", { path = vim.fn.getcwd(), upward = true })[1])
	if dir == nil or dir == "" then
		return
	end
	vim.cmd("e " .. dir)
end
