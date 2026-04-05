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
		"lget",
		fmt(
			[[
      GET http://localhost:{}/{}
      ]],
			{ i(1, "8080"), i(2, "path") }
		)
	),

	s(
		"lpost",
		fmta(
			[[
	     POST http://localhost:<>/<>
	     {
	       <>
	     }
	     ]],
			{ i(1, "8080"), i(2, "path"), i(3) }
		)
	),

	s(
		"ldelete",
		fmt(
			[[
      GET http://localhost:{}/{}
      ]],
			{ i(1, "8080"), i(2, "path") }
		)
	),
}
