local utils = require("xlsp.utils")

local M = {}

-- これ、以下の3つは同じような処理だった
-- "textDocument/definition"
-- "textDocument/typeDefinition"
-- "textDocument/implementation"

-- form telescope

---開くタイプのリクエスト
---@param action string リクエストのタイプ
local make_function = function(action, make_params)
	make_params = make_params or function(params)
		return params
	end

	---
	---@param filter_func fun(results: table): table 結果をフィルタする
	return function(filter_func)
		filter_func = filter_func or function(_results)
			return _results
		end

		local params = make_params(vim.lsp.util.make_position_params())
		vim.lsp.buf_request(0, "textDocument/" .. action, params, function(err, result, ctx, _)
			if err then
				vim.api.nvim_err_writeln("Error when executing textDocument/" .. action .. " : " .. err.message)
				return
			end
			local flattened_results = {}
			if result then
				-- textDocument/definition can return Location or Location[]
				if not vim.tbl_islist(result) then
					flattened_results = { result }
				end

				vim.list_extend(flattened_results, result)
			end

			local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding

			local filtered_result = filter_func(flattened_results)
			if #filtered_result == 0 then
				return
			elseif #filtered_result == 1 then
				utils.jump_to_location(filtered_result[1], offset_encoding)
			else
				local locations = vim.lsp.util.locations_to_items(filtered_result, offset_encoding)
				vim.fn.setqflist(locations)
				vim.cmd("ToggleQuickfix")
			end
		end)
	end
end

M.definition = make_function("definition")
M.typeDefinition = make_function("typeDefinition")
M.implementation = make_function("implementation")
M.references = make_function("references", function(params)
	params.context = { includeDeclaration = false }
	return params
end)

return M
