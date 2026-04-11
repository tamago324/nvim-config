if vim.api.nvim_call_function("FindPlugin", { "nvim-http-client" }) == 0 then
	do
		return
	end
end

local http_client = require("http_client")
http_client.setup({
	-- Default environment file to use
	default_env_file = ".http.env.json",

	-- Request timeout in milliseconds
	request_timeout = 30000, -- 30 seconds

	-- Split direction for response window ('right', 'left', 'top', 'bottom')
	split_direction = "right",

	-- Whether to create default keybindings (set to false when defining your own)
	create_keybindings = false,

	-- Profiling configuration
	profiling = {
		-- Enable request profiling
		enabled = true,
		-- Show timing metrics in response output
		show_in_response = true,
		-- Show detailed breakdown of timing metrics
		detailed_metrics = true,
	},
})

-- Set up Telescope integration
if pcall(require, "telescope") then
	require("telescope").load_extension("http_client")
end

-- Configure nvim-cmp for HTTP files
if pcall(require, "cmp") then
	local cmp = require("cmp")
	cmp.setup.filetype({ "http", "rest" }, {
		sources = cmp.config.sources({
			{ name = "http_method" }, -- HTTP methods (GET, POST, etc.)
			{ name = "http_header" }, -- HTTP headers
			{ name = "http_env_var" }, -- Environment variables
			-- { name = "buffer" }, -- Buffer text for general completions
		}),
	})
end

vim.api.nvim_create_augroup("user-http", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "user-http",
	pattern = "http",
	callback = function(args)
		local bufnr = args.buf

		require("user.keymap").set_list({
			{ "<Space>re", "<cmd>HttpEnvFile<cr>", desc = "Select HTTP environment file", bufnr = bufnr },
			{ "<Space>rs", "<cmd>HttpSaveResponse<cr>", desc = "Save HttpResponse to file", bufnr = bufnr },
			{ "<Space>rr", "<cmd>HttpRun<cr>", desc = "Run HTTP request", bufnr = bufnr },
			{ "<Space>rx", "<cmd>HttpStop<cr>", desc = "Stop HTTP request", bufnr = bufnr },
			{ "<Space>rd", "<cmd>HttpDryRun<cr>", desc = "DryRun HTTP request", bufnr = bufnr },
			{ "<Space>rv", "<cmd>HttpVerbose<cr>", desc = "Toggle verbose for HTTP request", bufnr = bufnr },
			{
				"<Space>rA",
				function()
					vim.cmd("HttpRunAll")
				end,
				desc = "Run all HTTP requests",
				bufnr = bufnr,
			},
			{
				"<Space>rf",
				"<cmd>Telescope http_client http_env_files<cr>",
				desc = "Select HTTP env file (Telescope)",
				bufnr = bufnr,
			},
			{
				"<Space>rh",
				"<cmd>Telescope http_client http_envs<cr>",
				desc = "Select HTTP env (Telescope)",
				bufnr = bufnr,
			},
			{ "<Space>rp", "<cmd>HttpProfiling<cr>", desc = "Toggle HttpProfiling request profiling", bufnr = bufnr },
			{ "<Space>rc", "<cmd>HttpCopyCurl<cr>", desc = "Copy curl command for HTTP request", bufnr = bufnr },
		})
	end,
})
