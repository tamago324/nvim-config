if vim.api.nvim_call_function("FindPlugin", { "hlchunk.nvim" }) == 0 then
	do
		return
	end
end

require("hlchunk").setup({
  chunk = {
    enable = true,
    duration = 150,
    delay = 200
  }
})
