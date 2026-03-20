if vim.api.nvim_call_function("FindPlugin", { "gitsigns.nvim" }) == 0 then
	do
		return
	end
end

-- http://www.shurey.com/js/works/unicode.html

require("gitsigns").setup({
  current_line_blame = true, -- これを有効にする
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' で行末に表示
    delay = 500,           -- カーソルを止めてから表示されるまでのミリ秒
  },
})
