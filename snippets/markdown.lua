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
		"detail",
		fmta(
			[[
      {{< details title="Details" closed="true" >}}
        []
      {{< /details >}}
      ]],
			{ i(1) },
			{
				delimiters = "[]",
			}
		)
	),
}
