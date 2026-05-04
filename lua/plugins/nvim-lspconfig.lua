if vim.api.nvim_call_function("FindPlugin", { "nvim-lspconfig" }) == 0 then
	do
		return
	end
end

local nlspsettings = require("nlspsettings")
local ts_organize_imports = "typescriptTools/organizeImports"

local function ignore_ts_organize_imports(client)
	if client == nil or client.name == "typescript-tools" then
		return
	end

	client.handlers = client.handlers or {}
	client.handlers[ts_organize_imports] = client.handlers[ts_organize_imports] or function() end
end

vim.lsp.config("*", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local jump_or_list = require("xlsp.jump_or_list")
		local map_opts = { buffer = ev.buf, noremap = true, silent = true }
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- typescript-tools sends organizeImports to every attached client.
		-- Give unsupported clients a no-op handler so the request does not abort.
		ignore_ts_organize_imports(client)

		-- vim.keymap.set("n", "<Up>", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", map_opts)
		-- vim.keymap.set("n", "<Down>", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", map_opts)
		vim.keymap.set("n", "<Up>", function()
			vim.diagnostic.jump({
				count = -1,
				float = false,
			})
		end)
		vim.keymap.set("n", "<Down>", function()
			vim.diagnostic.jump({
				count = 1,
				float = false,
			})
		end)

		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({
				border = "single",
			})
		end)

		-- K (hover) は hover.nvim を使う
		-- vim.keymap.set("n", "<A-o>", vim.diagnostic.setloclist, map_opts)
		vim.keymap.set("n", "<A-p>", function()
			vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.ERROR })
		end, map_opts)

		-- vim.keymap.set("n", "tr", "<Cmd>Lspsaga rename<CR>", map_opts)
		vim.keymap.set("n", "tr", function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end, { expr = true })

		vim.keymap.set({ "v", "n" }, "ta", require("actions-preview").code_actions)
		vim.keymap.set("n", "td", function()
			vim.lsp.buf.definition({ loclist = false })
		end, map_opts)
		vim.keymap.set("n", "to", function()
			vim.lsp.buf.references({ includeDeclaration = false }, { loclist = false })
		end, map_opts)
		vim.keymap.set("n", "tt", function()
			vim.lsp.buf.type_definition({ loclist = false })
		end, map_opts)
		vim.keymap.set("n", "ti", function()
			vim.lsp.buf.implementation({ loclist = false })
		end, map_opts)
		vim.keymap.set("n", "tl", require("xlsp.ts_def_or_ref").run, map_opts)
	end,
})

nlspsettings.setup({
	config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
	local_settings_dir = ".nlsp-settings",
	local_settings_root_markers_fallback = { ".git" },
	append_default_schemas = true,
	loader = "json",
	ignored_servers = {},
	nvim_notify = {
		enable = true,
		timeout = 300,
	},
	open_strictly = true,
})

-- require("typescript-tools").setup({
-- 	root_dir = function(bufnr, on_dir)
-- 		if deno.is_deno_project(bufnr) then
-- 			return
-- 		end
--
-- 		local root_dir = vim.fs.root(bufnr, {
-- 			"tsconfig.json",
-- 			"jsconfig.json",
-- 			"package.json",
-- 			".git",
-- 		}) or vim.fn.getcwd()
--
-- 		on_dir(root_dir)
-- 	end,
-- })

vim.diagnostic.config({
	underline = {
		-- 特定の重要度のみアンダーラインを引く設定
		severity = { min = vim.diagnostic.severity.WARN },
	},
})

-- -- https://blog.atusy.net/2025/08/29/copilot-via-nvim-lsp-client/
-- vim.lsp.inline_completion.enable(true)
--
-- vim.keymap.set("i", "<M-l>", "<cmd>lua vim.lsp.inline_completion.get()<cr>", { silent = true })
