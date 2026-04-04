if vim.api.nvim_call_function("FindPlugin", { "lualine.nvim" }) == 0 then
	do
		return
	end
end

local map = {
	["n"] = "N",
	["no"] = "O",
	["nov"] = "O",
	["noV"] = "O",
	["no"] = "O",
	["niI"] = "N",
	["niR"] = "N",
	["niV"] = "N",
	["nt"] = "N",
	["v"] = "V",
	["vs"] = "V",
	["V"] = "V-L",
	["Vs"] = "V-L",
	[""] = "V-B",
	["s"] = "V-B",
	["s"] = "S",
	["S"] = "S-L",
	[""] = "S-B",
	["i"] = "I",
	["ic"] = "I",
	["ix"] = "I",
	["R"] = "R",
	["Rc"] = "R",
	["Rx"] = "R",
	["Rv"] = "R",
	["Rvc"] = "R",
	["Rvx"] = "R",
	["c"] = "C",
	["cv"] = "EX",
	["ce"] = "EX",
	["r"] = "R",
	["rm"] = "M",
	["r?"] = "C",
	["!"] = "S",
	["t"] = "T",
}

local function get_mode()
	local mode_code = vim.api.nvim_get_mode().mode
	if map[mode_code] == nil then
		return mode_code
	end
	return map[mode_code]
end

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		-- component_separators = { left = "", right = "" },
		-- section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = false,
	},
	sections = {
		lualine_a = { get_mode },
		lualine_b = { { "filename", path = 4, } },
		lualine_c = {
			"filetype",
			{
				"diagnostics",
				-- colored = false,
				diagnostics_color = {
					error = "DiagnosticSignError", -- Changes diagnostics' error color.
					warn = "DiagnosticSignWarn",	 -- Changes diagnostics' warn color.
					info = "DiagnosticSignInfo",	 -- Changes diagnostics' info color.
					hint = "DiagnosticSignHint",	 -- Changes diagnostics' hint color.
				},
				-- symbols = { error = "E", warn = "W", info = "I", hint = "H" },
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
			},
		},
		-- lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_x = { "branch" },
		-- lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { "filename", path = 4, } },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
