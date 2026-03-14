require("nvim_mappings")

function _G.pprint(...)
	local objects = vim.tbl_map(vim.inspect, { ... })
	print(unpack(objects))
end

function _G.has_plugin(name)
	return vim.api.nvim_call_function("FindPlugin", { name }) == 0
end

local function load_rc_files()
	local files = vim.api.nvim_eval([[sort(glob(g:lua_plugin_config_dir .. '/*.lua', '', v:true))]])
	for _, file in ipairs(files) do
		-- local name = file:sub(#vim.g.lua_plugin_config_dir+2, file:len()-4)
		-- require('rc/' .. name)
		dofile(file)
	end
end
load_rc_files()

-- 指定のファイルをリロードする

-- function plenary_luarocks()
--   -- https://github.com/tjdevries/config_manager/blob/49fe3dc80f077b051f3bfb958413ff6e74920f83/xdg_config/nvim/lua/init.lua
--   -- 1回のみ実行する
--   -- if false then
--   --   local neorocks = require('plenary.neorocks')
--   --
--   --   -- package-name, lua-name
--   --   -- neorocks.install('penlight', 'pl')
--   --   -- neorocks.install('microlight', 'ml')
--   --   -- neorocks.install('moses')
--   --   -- neorocks.install('Lua-cURL')
--   --
--   --   -- local pl = require'pl' で使える！
--   -- end
-- end
-- plenary_luarocks()
