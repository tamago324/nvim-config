if vim.api.nvim_call_function("FindPlugin", { "nvim-cmp" }) == 0 then
	do
		return
	end
end

local cmp = require'cmp'

local kind_text_map = {
	Text = " ",
	Method = " ",
	Function = " ",
	Constructor = "コンストラクタ",
	Variable = "変数",
	Field = "フィールド",
	Class = "クラス",
	Interface = "インターフェース",
	Module = "モジュール",
	Property = "プロパティ",
	Unit = "ユニット",
	Value = "値",
	Enum = "Enum",
	Keyword = "キーワード",
	-- Snippet = "スニペット",
	Snippet = "󿨀 ",
	-- Color = "色",
	Color = "󿣗 ",
	File = "󿢚 ",
	Folder = " ",
	EnumMember = "列挙メンバ",
	Constant = "定数",
	Struct = "構造愛",
	Event = "󿝀 ",
	Reference = "リファレンス",
	Operator = "オペレータ",
	TypeParameter = "型パラメータ",
}


-- カッコをつける
local addParen = function(abbr)
	if vim.endswith(abbr, ")") or vim.endswith(abbr, "~") then
		return abbr
	end
	return abbr .. "()"
end

local cmp_format = function(opts)
	return function(entry, vim_item)
		if vim.tbl_contains({ "Function", "Method" }, vim_item.kind) then
			vim_item.abbr = addParen(vim_item.abbr)
		end

		vim_item.kind = opts.kind_map[vim_item.kind]
		vim_item.menu = opts.menu[entry.source.name] or entry.source.name

		if opts.max_width ~= nil then
			if #vim_item.abbr > opts.max_width then
				vim_item.abbr = string.sub(vim_item.abbr, 1, opts.max_width) .. "…"
			end
		end
		return vim_item
	end
end

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		-- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
		-- ['<C-f>'] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-g>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end),

		["<Down>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end),

		["<Up>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end),

		-- https://github.com/hrsh7th/nvim-cmp/issues/407
		["<C-e>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.close()
			end
			fallback()
		end),
	}),

	-- ここではすべてのバッファで使用するソースを指定する
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
		-- { name = "rg" },
		-- { name = "nvim_lua" },
	},

	-- completion = {
	--   -- menuone:  候補が1つでも表示
	--   -- noselect: 自動で候補を表示しない
	--   -- noinsert: 自動で候補を挿入しない
	--   completeopt = 'menuone,noselect,noinsert'
	-- },

	preselect = cmp.PreselectMode.None,

	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = cmp_format({
			kind_map = kind_text_map,
			max_width = nil,
			menu = {
				buffer = "[BUF]",
				nvim_lsp = "[LSP]",
				luasnip = "[SNIP]",
				nvim_lua = "[LUA]",
				zsh = "[ZSH]",
				-- deol_history = "[deol]",
				-- rg = "[GREP]",
				necosyntax = "[SYNTAX]",
			},
		}),
	},

	window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
		-- completion = {
		-- 	border = "rounded",
		-- 	scrollbar = "",
		-- },
		-- documentation = {
		-- 	border = "rounded",
		-- 	scrollbar = "",
		-- },
	},
})

-- deoledit
-- do
-- 	local deoledit_ops = {
-- 		mapping = {
-- 			["<CR>"] = cmp.mapping(function(fallback)
-- 				if cmp.visible() then
-- 					cmp.close()
-- 				end
-- 				fallback()
-- 			end, { "i", "s" }),
--
-- 			["<C-e>"] = cmp.mapping(function(fallback)
-- 				-- deol-hisotry のやつ
-- 				if cmp.visible() then
-- 					-- 開いていたら閉じる
-- 					cmp.close()
-- 				end
--
-- 				-- suggestion_text をセットする
-- 				local virt_text = deol_suggestions.get_current_virt_text()
-- 				if virt_text and #virt_text > 0 then
-- 					-- 末尾に移動
-- 					vim.api.nvim_exec("normal! $", false)
-- 					-- セットして、末尾のカーソル移動
-- 					vim.api.nvim_put({ virt_text }, "c", true, true)
-- 				else
-- 					fallback()
-- 				end
-- 			end, { "i", "s" }),
-- 		},
-- 	}
--
-- 	if vim.fn.has("win64") ~= 1 then
-- 		deoledit_ops.sources = {
-- 			{ name = "zsh" },
-- 		}
-- 	end
--
-- 	cmp.setup.filetype("deoledit", deoledit_ops)
-- end

-- cmp.setup.filetype("javascript", {
-- 	sources = {
-- 		{ name = "nvim_lsp" },
-- 		{ name = "buffer" },
-- 		{ name = "path" },
-- 		{ name = "luasnip" },
-- 	},
-- })

-- cmp.setup.filetype("plantuml", {
-- 	sources = {
-- 		{ name = "necosyntax" },
-- 	},
-- })

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- cmp.setup.cmdline(':', {
--   sources = {
--     { name = 'cmdline' }
--   }
-- })

-- require("cmp_deol_history.suggestions").setup({
-- 	hl_group = "Comment",
-- 	filetypes = {
-- 		"deoledit",
-- 	},
-- })

-- if vim.fn.has("win64") ~= 1 then
-- 	require("cmp_zsh").setup({
-- 		zshrc = true,
-- 		filetypes = { "deoledit" },
-- 	})
-- end

-- require("cmp_necosyntax").setup({
-- 	filetypes = { "plantuml", "make", "zsh" },
-- })
