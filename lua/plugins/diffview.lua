if vim.api.nvim_call_function("FindPlugin", { "diffview.nvim" }) == 0 then
	do
		return
	end
end

require('diffview').setup({
  default_args = {
    DiffviewOpen = { "--imply-local" },
    DiffviewFileHistory = {"--no-merges"},
  }
})
