local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")

local function normalize_opts(opts)
	if type(opts) == "string" then
		return { type = opts }
	end

	return opts or {}
end

local function normalize_plugin_name(name)
	local normalized = name

	for _, pattern in ipairs({
		"^nvim%-",
		"^vim%-",
		"%.nvim$",
		"%.vim$",
	}) do
		normalized = normalized:gsub(pattern, "")
	end

	return normalized
end

local function get_filetype(opts)
	local filetype = opts.type or opts.filetype or "lua"

	if filetype ~= "lua" and filetype ~= "vim" then
		error(string.format("unsupported plugin filetype: %s", filetype))
	end

	return filetype
end

local function build_target_basename(name, filetype)
	local basename = normalize_plugin_name(name)
	local suffix = "." .. filetype

	if basename:sub(-#suffix) == suffix then
		return basename
	end

	return basename .. suffix
end

local function build_target_path(entry, filetype)
	local dir = (filetype == "vim" and vim.g.vim_plugin_config_dir) or vim.g.lua_plugin_config_dir
	local basename = build_target_basename(entry.name, filetype)

	return string.format("%s/%s", dir, basename)
end

local function build_template(entry, filetype)
	if filetype == "lua" then
		return {
			string.format('if vim.api.nvim_call_function("FindPlugin", { "%s" }) == 0 then', entry.dir_name),
			"\tdo",
			"\t\treturn",
			"\tend",
			"end",
		}
	end

	return {
		"scriptencoding utf-8",
		string.format("UsePlugin '%s'", entry.dir_name),
	}
end

local function list_plugins(filetype)
	local results = {}
	local plugs = vim.g.plugs or {}

	for name, plug in pairs(plugs) do
		local dir = plug.dir
		if type(dir) == "string" and vim.fn.isdirectory(dir) == 1 then
			local entry = {
				name = name,
				dir = dir,
				dir_name = vim.fn.fnamemodify(dir, ":t"),
			}
			entry.target = build_target_path(entry, filetype)
			entry.exists = vim.fn.filereadable(entry.target) == 1

			table.insert(results, entry)
		end
	end

	table.sort(results, function(left, right)
		return left.name < right.name
	end)

	return results
end

local function make_entry(filetype)
	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 4 },
			{ width = 28 },
			{ width = 26 },
			{ remaining = true },
		},
	})

	return function(entry)
		return {
			value = entry,
			ordinal = table.concat({
				entry.name,
				entry.dir_name,
				vim.fn.fnamemodify(entry.target, ":t"),
			}, " "),
			display = function()
				return displayer({
					{ entry.exists and "old" or "new", entry.exists and "Comment" or "String" },
					entry.name,
					{ entry.dir_name, "Comment" },
					vim.fn.fnamemodify(entry.target, ":t"),
				})
			end,
			filename = entry.target,
			filetype = filetype,
		}
	end
end

local function open_or_create_file(entry, filetype)
	local target = build_target_path(entry, filetype)

	vim.fn.mkdir(vim.fn.fnamemodify(target, ":h"), "p")
	vim.cmd("drop " .. vim.fn.fnameescape(target))

	if vim.fn.filereadable(target) == 1 then
		return
	end

	vim.api.nvim_buf_set_lines(0, 0, -1, false, build_template(entry, filetype))
	vim.cmd("write")
end

return function(opts)
	opts = normalize_opts(opts)

	local filetype = get_filetype(opts)
	local results = list_plugins(filetype)

	pickers.new(opts, {
		prompt_title = string.format("Touch Plugin (%s)", filetype),
		finder = finders.new_table({
			results = results,
			entry_maker = make_entry(filetype),
		}),
		sorter = sorters.get_generic_fuzzy_sorter(),
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()

				actions.close(prompt_bufnr)
				open_or_create_file(selection.value, filetype)
			end)

			return true
		end,
	}):find()
end
