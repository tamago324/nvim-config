return {
	settings = {
		Lua = {
			-- runtime = {
			--   path = path
			-- },
			workspace = {
				-- library = library,
				library = vim.tbl_extend("force", {
					-- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
					-- vim-plug で管理しているプラグインの /lua を入れる
				}, vim.fn.PlugLuaLibraries()),
				preloadFileSize = 500,
			},
      ["diagnostics.globals"]= {
        "vim"
      }
		},
	},
}
