local notify = require("notify")

return function(message, level)
	notify(message, level, {
		title = "lir.nvim",
		timeout = 500,
	})
end
