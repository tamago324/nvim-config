local utils = require("xlsp.utils")

local M = {}

local function get_current_node(bufnr)
	local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr })
	if ok and node then
		return node
	end

	if vim.treesitter.get_node then
		ok, node = pcall(vim.treesitter.get_node)
		if ok and node then
			return node
		end
	end

	return nil
end

local function get_locals_query(bufnr)
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
	if not ok or not parser then
		return nil, nil
	end

	local trees = parser:parse()
	local tree = trees and trees[1]
	if not tree then
		return nil, nil
	end

	local filetype = vim.bo[bufnr].filetype
	local lang = vim.treesitter.language.get_lang(filetype) or filetype
	local ok_query, query = pcall(vim.treesitter.query.get, lang, "locals")
	if not ok_query then
		return nil, nil
	end

	return query, tree:root()
end

-- カーソル下の要素が定義か？
local function is_definition_under_cursor(bufnr)
	local node = get_current_node(bufnr)
	if not node then
		return false
	end

	local query, root = get_locals_query(bufnr)
	if not query or not root then
		return false
	end

	local ancestor_ids = {}
	local current = node
	while current do
		ancestor_ids[current:id()] = true
		current = current:parent()
	end

	for id, captured_node in query:iter_captures(root, bufnr, 0, -1) do
		local capture_name = query.captures[id]
		if captured_node and ancestor_ids[captured_node:id()] and vim.startswith(capture_name, "local.definition") then
			return true
		end
	end

	return false
end

local function make_request_params(action)
	local params = vim.lsp.util.make_position_params(0)
	if action == "references" then
		params.context = { includeDeclaration = false }
	end
	return params
end

local function normalize_result(result)
	if not result then
		return {}
	end

	if vim.tbl_islist(result) then
		return result
	end

	return { result }
end

local function location_key(location)
	local uri = location.uri or location.targetUri
	local range = location.range or location.targetSelectionRange or location.targetRange
	if not uri or not range then
		return nil
	end

	return table.concat({
		uri,
		range.start.line,
		range.start.character,
		range["end"].line,
		range["end"].character,
	}, ":")
end

local function collect_locations(bufnr, action, done)
	local method = "textDocument/" .. action
	local params = make_request_params(action)

	vim.lsp.buf_request_all(bufnr, method, params, function(results)
		local errors = {}
		local locations = {}
		local seen = {}

		for client_id, response in pairs(results) do
			if response.error then
				table.insert(errors, response.error.message or tostring(response.error))
			else
				local client = vim.lsp.get_client_by_id(client_id)
				local offset_encoding = client and client.offset_encoding or "utf-16"
				for _, location in ipairs(normalize_result(response.result)) do
					local key = location_key(location)
					if key and not seen[key] then
						seen[key] = true
						table.insert(locations, {
							location = location,
							offset_encoding = offset_encoding,
						})
					end
				end
			end
		end

		if #errors > 0 and #locations == 0 then
			vim.notify(table.concat(errors, "\n"), vim.log.levels.ERROR)
			return
		end

		done(locations)
	end)
end

local function to_qf_items(locations)
	local items = {}
	for _, entry in ipairs(locations) do
		local converted = vim.lsp.util.locations_to_items({ entry.location }, entry.offset_encoding)
		if converted[1] then
			table.insert(items, converted[1])
		end
	end
	return items
end

local function remove_duplicate_qflist_items(items)
	local deduped = {}
	local seen = {}

	for _, item in ipairs(items) do
		local key = table.concat({
			item.bufnr or item.filename or "",
			item.lnum or "",
			item.col or "",
		}, ":")

		if not seen[key] then
			seen[key] = true
			table.insert(deduped, item)
		end
	end

	return deduped
end

function M.run()
	local bufnr = vim.api.nvim_get_current_buf()
	local action = is_definition_under_cursor(bufnr) and "references" or "definition"

	collect_locations(bufnr, action, function(locations)
		if #locations == 0 then
			vim.notify("No " .. action .. " found", vim.log.levels.INFO)
			return
		end

		if #locations == 1 then
			utils.jump_to_location(locations[1].location, locations[1].offset_encoding)
			return
		end

		local qflist_items = remove_duplicate_qflist_items(to_qf_items(locations))
		vim.fn.setqflist({}, "r", {
			title = "LSP " .. action,
			items = qflist_items,
		})
		vim.cmd("ToggleQuickfix")
	end)
end

return M
