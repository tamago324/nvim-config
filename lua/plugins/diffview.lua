if vim.api.nvim_call_function("FindPlugin", { "diffview.nvim" }) == 0 then
	do
		return
	end
end

local actions = require("diffview.actions")
local uv = vim.loop

vim.keymap.set("n", "<Space>do", function()
	local filename = vim.fn.expand("%:p:t")
	-- もし、すでに diffopen があるのであれば、そのタブに移動する。
	local tabpages = vim.fn.gettabinfo()
	for _, value in pairs(tabpages) do
		if value.variables["diffview_view_initialized"] then
			vim.cmd("tabnext " .. value.tabnr)
			actions.focus_files()
			uv.sleep(100)
			vim.fn.search(filename)
			return
		end
	end

	vim.cmd([[DiffviewOpen]])
end, { noremap = true })

-- コンフリクト解消
--   h <<< を採用
--   l >>> を採用
--   a 両方採用
--   b どちらも不採用

require("diffview").setup({
	default_args = {
		DiffviewOpen = { "--imply-local" },
		DiffviewFileHistory = { "--no-merges" },
	},
	file_panel = {
		listing_style = "tree", -- One of 'list' or 'tree'
		tree_options = { -- Only applies when listing_style is 'tree'
			flatten_dirs = true, -- Flatten dirs that only contain one single dir
			folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
		},
		win_config = function()
			local c = { type = "float" }
			local editor_width = vim.o.columns
			local editor_height = vim.o.lines
			c.width = math.min(100, editor_width)
			c.height = math.min(30, editor_height)
			c.col = math.floor(editor_width * 0.5 - c.width * 0.5)
			c.row = math.floor(editor_height * 0.8 - c.height * 0.5)
			return c
		end,
	},
	view = {
		merge_tool = {
			layout = "diff4_mixed",
			disable_diagnostics = true,
			winbar_info = true,
		},
	},
	keymaps = {
		disable_defaults = false, -- Disable the default keymaps
		view = {
			-- The `view` bindings are active in the diff buffers, only when the current
			-- tabpage is a Diffview.
			{
				"n",
				"<tab>",
				actions.select_next_entry,
				{ desc = "Open the diff for the next file" },
			},
			{
				"n",
				"<s-tab>",
				actions.select_prev_entry,
				{ desc = "Open the diff for the previous file" },
			},
			{
				"n",
				"[F",
				actions.select_first_entry,
				{ desc = "Open the diff for the first file" },
			},
			{
				"n",
				"]F",
				actions.select_last_entry,
				{ desc = "Open the diff for the last file" },
			},
			{
				"n",
				"gf",
				actions.goto_file_edit,
				{ desc = "Open the file in the previous tabpage" },
			},
			{ "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
			{ "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
			-- { "n", ",e", actions.focus_files, { desc = "Bring focus to the file panel" } },
			{ "n", "<C-e>", actions.toggle_files, { desc = "Toggle the file panel." } },
			{
				"n",
				"g<C-x>",
				actions.cycle_layout,
				{ desc = "Cycle through available layouts." },
			},
			{
				"n",
				"[x",
				actions.prev_conflict,
				{ desc = "In the merge-tool: jump to the previous conflict" },
			},
			{
				"n",
				"]x",
				actions.next_conflict,
				{ desc = "In the merge-tool: jump to the next conflict" },
			},
			-- h <<< を採用
			-- l >>> を採用
			-- a 両方採用
			-- b どちらも不採用
			{
				"n",
				",ch",
				actions.conflict_choose("ours"),
				{ desc = "Choose the OURS version of a conflict" },
			},
			{
				"n",
				",cl",
				actions.conflict_choose("theirs"),
				{ desc = "Choose the THEIRS version of a conflict" },
			},
			{
				"n",
				",cb",
				actions.conflict_choose("base"),
				{ desc = "Choose the BASE version of a conflict" },
			},
			{
				"n",
				",ca",
				actions.conflict_choose("all"),
				{ desc = "Choose all the versions of a conflict" },
			},
			{ "n", "dx", actions.conflict_choose("none"), { desc = "Delete the conflict region" } },
			{
				"n",
				",cL",
				actions.conflict_choose_all("ours"),
				{ desc = "Choose the OURS version of a conflict for the whole file" },
			},
			{
				"n",
				",cL",
				actions.conflict_choose_all("theirs"),
				{ desc = "Choose the THEIRS version of a conflict for the whole file" },
			},
			{
				"n",
				",cB",
				actions.conflict_choose_all("base"),
				{ desc = "Choose the BASE version of a conflict for the whole file" },
			},
			{
				"n",
				",cA",
				actions.conflict_choose_all("all"),
				{ desc = "Choose all the versions of a conflict for the whole file" },
			},
			{
				"n",
				"dX",
				actions.conflict_choose_all("none"),
				{ desc = "Delete the conflict region for the whole file" },
			},
		},
		file_panel = {
			{
				"n",
				"j",
				actions.next_entry,
				{ desc = "Bring the cursor to the next file entry" },
			},
			{
				"n",
				"<down>",
				actions.next_entry,
				{ desc = "Bring the cursor to the next file entry" },
			},
			{
				"n",
				"k",
				actions.prev_entry,
				{ desc = "Bring the cursor to the previous file entry" },
			},
			{
				"n",
				"<up>",
				actions.prev_entry,
				{ desc = "Bring the cursor to the previous file entry" },
			},
			{
				"n",
				"<cr>",
				function()
					actions.select_entry()
					actions.close()
				end,
				{ desc = "Open the diff for the selected entry" },
			},
			{
				"n",
				"o",
				function()
					actions.select_entry()
					actions.close()
				end,
				{ desc = "Open the diff for the selected entry" },
			},
			{
				"n",
				"l",
				actions.select_entry,
				{ desc = "Open the diff for the selected entry" },
			},
			{
				"n",
				"-",
				actions.toggle_stage_entry,
				{ desc = "Stage / unstage the selected entry" },
			},
			{
				"n",
				"X",
				actions.restore_entry,
				{ desc = "Restore entry to the state on the left side" },
			},
			{
				"n",
				"S",
				function() end,
			},
			{ "n", "L", actions.open_commit_log, { desc = "Open the commit log panel" } },
			{ "n", "zo", actions.open_fold, { desc = "Expand fold" } },
			{ "n", "h", actions.close_fold, { desc = "Collapse fold" } },
			{ "n", "zc", actions.close_fold, { desc = "Collapse fold" } },
			{ "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
			{ "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
			{ "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
			{ "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
			{ "n", "<c-f>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
			{ "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
			{
				"n",
				"<s-tab>",
				actions.select_prev_entry,
				{ desc = "Open the diff for the previous file" },
			},
			{
				"n",
				"[F",
				actions.select_first_entry,
				{ desc = "Open the diff for the first file" },
			},
			{ "n", "]F", actions.select_last_entry, { desc = "Open the diff for the last file" } },
			{
				"n",
				"gf",
				actions.goto_file_edit,
				{ desc = "Open the file in the previous tabpage" },
			},
			{ "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
			{ "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
			{
				"n",
				"i",
				actions.listing_style,
				{ desc = "Toggle between 'list' and 'tree' views" },
			},
			{
				"n",
				"f",
				actions.toggle_flatten_dirs,
				{ desc = "Flatten empty subdirectories in tree listing style" },
			},
			{
				"n",
				"R",
				actions.refresh_files,
				{ desc = "Update stats and entries in the file list" },
			},
			-- { "n", "<C-e>", actions.focus_files, { desc = "Bring focus to the file panel" } },
			{ "n", "<C-e>", actions.toggle_files, { desc = "Toggle the file panel" } },
			{ "n", "q", actions.toggle_files, { desc = "Toggle the file panel" } },
			{ "n", "<Esc>", actions.toggle_files, { desc = "Toggle the file panel" } },
			{ "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle available layouts" } },
			{ "n", "[x", actions.prev_conflict, { desc = "Go to the previous conflict" } },
			{ "n", "]x", actions.next_conflict, { desc = "Go to the next conflict" } },
			{ "n", "g?", actions.help("file_panel"), { desc = "Open the help panel" } },
			{
				"n",
				",cO",
				actions.conflict_choose_all("ours"),
				{ desc = "Choose the OURS version of a conflict for the whole file" },
			},
			{
				"n",
				",cT",
				actions.conflict_choose_all("theirs"),
				{ desc = "Choose the THEIRS version of a conflict for the whole file" },
			},
			{
				"n",
				",cB",
				actions.conflict_choose_all("base"),
				{ desc = "Choose the BASE version of a conflict for the whole file" },
			},
			{
				"n",
				",cA",
				actions.conflict_choose_all("all"),
				{ desc = "Choose all the versions of a conflict for the whole file" },
			},
			{
				"n",
				"dX",
				actions.conflict_choose_all("none"),
				{ desc = "Delete the conflict region for the whole file" },
			},

			-- git
			{
				"n",
				"cc",
				function()
					actions.close()
					vim.cmd([[Git commit]])
				end,
				{ desc = "Commit staged changes" },
			},
			{
				"n",
				"ca",
				function()
					actions.close()
					vim.cmd([[Git commit --amend]])
				end,
				{ desc = "Amend the last commit" },
			},
		},
	},
})
