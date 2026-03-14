if vim.api.nvim_call_function("FindPlugin", { "nvim-web-devicons" }) == 0 then
	do
		return
	end
end

-- do
--   return
-- end

-- local devicons = require'nvim-web-devicons'

require("nvim-web-devicons").setup({
	override = {
		["lir_folder_icon"] = {
			icon = "",
			color = "#7ebae4",
			name = "LirFolderNode",
		},
		["vue"] = {
			icon = "󿵂",
			color = "#8dc149",
			name = "Vue",
		},
		[".babelrc"] = {
			icon = "",
			color = "#cbcb41",
			name = "Babelrc",
		},
		["svg"] = {
			icon = "",
			color = "#cbcb41",
			name = "Svg",
		},
		["txt"] = {
			icon = "󿜓",
			color = "#89e051",
			cterm_color = "113",
			name = "Txt",
		},

		-- 正しく追加されていなかったため、こうした
		["default"] = {
			icon = "",
			color = "#6d8086",
			cterm_color = "66",
			name = "Default",
		},
	},
})
