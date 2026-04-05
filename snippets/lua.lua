local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.s
local sn = ls.sn
local t = ls.t
local i = ls.i
local f = ls.f
local c = ls.c
local d = ls.d

return {
	s(
		"lam",
		fmt(
			[[
      function({})
        {}
      end
      ]],
			{ i(1), i(2) }
		)
	),

	s(
		"if",
		fmt(
			[[
	     if {} then
	       {}
	     end
	   ]],
			{ i(1), i(2) }
		)
	),

	s("req", fmt("require'{}'", { i(1) })),

	s(
		"else",
		fmt(
			[[
      else
        {}
      ]],
			{ i(1) }
		)
	),
	s(
		"elseif",
		fmt(
			[[
    elseif {}
      {}
  ]],
			{ i(1), i(0) }
		)
	),

	s(
		"for",
		fmt(
			[[
      for {}, {} in ipairs({}) do
        {}
      end
    ]],
			{ i(1, "k"), i(2, "v"), i(3), i(0) }
		)
	),

	s(
		"forin",
		fmt(
			[[
      for {} in {} do
        {}
      end
      ]],
			{ i(1, "item"), i(2, "list"), i(0) }
		)
	),

	s(
		"foreach",
		fmt(
			[[
    for {}, {} in ipairs({}) do
      {}
    end
    ]],
			{ i(1, "_"), i(2, "v"), i(3), i(0) }
		)
	),

	s(
		"while",
		fmt(
			[[
    while {} do
      {}
    end
  ]],
			{ i(1), i(0) }
		)
	),

	s(
		"fmt",
		fmt(
			[[
    string.format('{}', {})
  ]],
			{ i(1), i(2) }
		)
	),

	s({ trig = "func", wordTrig = true }, {
		c(1, {
			sn(nil, {
				t({ "function " }),
				i(1, { "name" }),
				t({ "(" }),
				i(2),
				t({ ")" }),
				t({ "", "" }),
				t({ "  " }),
				i(3),
				t({ "", "" }),
				t({ "end" }),
			}),
			sn(nil, {
				t({ "local " }),
				i(1, { "name" }),
				t({ " = function(" }),
				i(2),
				t({ ")" }),
				t({ "", "" }),
				t({ "  " }),
				i(3),
				t({ "", "" }),
				t({ "end" }),
			}),
		}),
		i(0),
	}),

	s("snip", {
		t({ "s(", '  "' }),
		i(1),
		t('",', ""),
		t({ "fmt([[", "    " }),
		i(0),
		t({ "", "    ]]", "))" }),
	}),

	-- parse({ trig = "stylua" }, {
	-- 	"-- stylua: ignore${0}",
	-- }),
}
