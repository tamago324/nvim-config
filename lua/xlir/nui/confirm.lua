local input = require("xlir.nui.input").input

local close_prompt = function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "i", true)
end

function backspace()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS>", true, false, true), "i", true)
end

local confirm = function(opts)
	vim.validate({
		title = { opts.title, "string", false },
		border_color = { opts.border_color, "string", true },
		yes = { opts.yes, "function", false },
		no = { opts.no, "function", true },
	})

	local no = vim.F.if_nil(opts.no, function() end)

	input({
		title = opts.title,
		prompt = "(Y)es, [N]o",
		border_color = opts.border_color,
		on_submit = function(value) end,
		on_change = function(value)
			if value == "y" then
				close_prompt()
				-- schedule で囲まないとだめだった
				vim.schedule(function()
					opts.yes()
				end)
			elseif value == "n" then
				close_prompt()
				vim.schedule(function()
					no()
				end)
			else
				backspace()
			end
		end,
	})
end

return {
	confirm = confirm,
}
