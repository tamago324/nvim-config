if vim.api.nvim_call_function("FindPlugin", { "actions-preview.nvim" }) == 0 then
	do
		return
	end
end

require('actions-preview').setup({
  backend = {"telescope"},
  telescope = vim.tbl_extend(
    "force",
    require("telescope.themes").get_dropdown(),
    {
      make_avlue = nil,
      make_make_display = nil
    }
  )
  -- options for nui.nvim components
  -- nui = {
  --   -- component direction. "col" or "row"
  --   dir = "col",
  --   -- keymap for selection component: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/menu#keymap
  --   keymap = nil,
  --   -- options for nui Layout component: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/layout
  --   layout = {
  --     position = "50%",
  --     size = {
  --       width = "60%",
  --       height = "90%",
  --     },
  --     min_width = 40,
  --     min_height = 10,
  --     relative = "editor",
  --   },
  --   -- options for preview area: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
  --   preview = {
  --     size = "60%",
  --     border = {
  --       style = "rounded",
  --       padding = { 0, 1 },
  --     },
  --   },
  --   -- options for selection area: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/menu
  --   select = {
  --     size = "40%",
  --     border = {
  --       style = "rounded",
  --       padding = { 0, 1 },
  --     },
  --   },
  -- },
})
