local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local s = ls.s
local sn = ls.sn
local t = ls.t
local i = ls.i
local f = ls.f
local c = ls.c
local d = ls.d

return {
	s(
		"if",
		fmta(
			[[
      if (<>) {
        <>
      }
      ]],
			{ i(1, "condition"), i(0) }
		)
	),

	s(
		"else",
		fmta(
			[[
      else {
        <>
      }
      ]],
			{ i(0) }
		)
	),

	s(
		"for",
		fmta(
			[[
      for (const <> of <>) {
        <>
      }
      ]],
			{ i(1, "iterator"), i(2, "object"), i(0) }
		)
	),

	s(
		"switch",
		fmta(
			[[
      switch (<>) {
        case <>:
          <>
        default:
      }
      ]],
			{ i(1), i(2), i(0) }
		)
	),

	s(
		"import",
		fmta(
			[[
      import <> from '<>';
      ]],
			{ i(1), i(2, "module") }
		)
	),

	-- 関数定義 (const xxx = (...) => {...} の形式) のスニペットを書いてほしい
	s(
		"fn",
		fmt(
			[[
      const [] = ([]) => {
        []
      };
      ]],
			{ i(1, "name"), i(2), i(0) },
			{
				delimiters = "[]",
			}
		)
	),

	s(
		"lam",
		fmt(
			[[
      ([]) => {[]}
      ]],
			{ i(1), i(0) },
			{ delimiters = "[]" }
		)
	),
}
