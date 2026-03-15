if vim.api.nvim_call_function("FindPlugin", { "nvim-hlslens" }) == 0 then
	do
		return
	end
end

require("hlslens").setup({
	-- 一番近いもののみ表示する
	nearest_only = true,

	-- build_position_cb = function(plist, _, _, _)
	-- 	require("scrollbar.handlers.search").handler.show(plist.start_pos)
	-- end,
})

-- vim.cmd([[
--     augroup scrollbar_search_hide
--         autocmd!
--         autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
--     augroup END
-- ]])
