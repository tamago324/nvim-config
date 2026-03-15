if vim.api.nvim_call_function("FindPlugin", { "nvim-lspconfig" }) == 0 then
	do
		return
	end
end

local nlspsettings = require('nlspsettings')

vim.lsp.config("*", {
  capabilities = require('cmp_nvim_lsp').default_capabilities()
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function (ev)
    local jump_or_list = require("xlsp.jump_or_list")
    local map_opts = { buffer = ev.buf, noremap = true, silent = true }

    -- vim.keymap.set("n", "<Up>", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", map_opts)
    -- vim.keymap.set("n", "<Down>", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", map_opts)
    vim.keymap.set('n', '<Up>', function()
      vim.diagnostic.jump({
        count = -1,
        float = false,
      })
    end)
    vim.keymap.set('n', '<Down>', function()
      vim.diagnostic.jump({
        count = 1,
        float = false,
      })
    end)

    -- K (hover) は hover.nvim を使う
    vim.keymap.set("n", "<A-o>", vim.diagnostic.setloclist, map_opts)
    vim.keymap.set("n", "<A-p>", function()
      vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.ERROR })
    end, map_opts)

    -- vim.keymap.set("n", "tr", "<Cmd>Lspsaga rename<CR>", map_opts)
    vim.keymap.set("n", "tr", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true })

    vim.keymap.set({ "v", "n" }, "ta", require("actions-preview").code_actions)
    vim.keymap.set("n", "td", jump_or_list.definition, map_opts)
    vim.keymap.set("n", "tl", jump_or_list.references, map_opts)
    vim.keymap.set("n", "tt", jump_or_list.typeDefinition, map_opts)
    vim.keymap.set("n", "ti", jump_or_list.implementation, map_opts)
    -- vim.keymap.set('n', 'td', '<CMD>Glance definitions<CR>', map_opts)
    -- vim.keymap.set('n', 'tl', '<CMD>Glance references<CR>', map_opts)
    -- vim.keymap.set('n', 'tt', '<CMD>Glance type_definitions<CR>', map_opts)
    -- vim.keymap.set('n', 'ti', '<CMD>Glance implementations<CR>', map_opts)
  end
})

nlspsettings.setup({
  config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
  local_settings_dir = ".nlsp-settings",
  local_settings_root_markers_fallback = { '.git' },
  append_default_schemas = true,
  loader = 'json',
  ignored_servers = {},
  nvim_notify = {
    enable = true,
    timeout = 300
  },
  open_strictly = true
})

