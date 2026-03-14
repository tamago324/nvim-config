return function()
	local dir = require("lspconfig.util").find_git_ancestor(vim.fn.getcwd())
	if dir == nil or dir == "" then
		return
	end
	vim.cmd("e " .. dir)
end
