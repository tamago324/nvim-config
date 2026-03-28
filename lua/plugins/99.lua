if vim.api.nvim_call_function("FindPlugin", { "99" }) == 0 then
	do
		return
	end
end

local _99 = require("99")

-- .plugged/99/lua/99/providers.lua をベースにして、Provider を定義した
--- @class GitHubCopilotProvider : _99.Providers.BaseProvider
local GitHubCopilotProvider = setmetatable({}, { __index = _99.Providers.BaseProvider })

--- @param query string
--- @param context _99.Prompt
--- @return string[]
function GitHubCopilotProvider._build_command(_, query, context)
	return {
		"copilot",
		"--yolo",
		"--model",
		context.model,
		"--no-ask-user",
		"--prompt",
		query,
	}
end

--- @return string
function GitHubCopilotProvider._get_provider_name()
	return "GitHubCopilotProvider"
end

--- @return string
function GitHubCopilotProvider._get_default_model()
	return "claude-sonnet-4.6"
end

function GitHubCopilotProvider.fetch_models(callback)
	callback({
		"claude-sonnet-4.6",
		"claude-haiku-4.5",
		"claude-opus-4.6",
		"gpt-5.4",
		"gpt-5.4-mini",
		"gpt-5-mini",
	}, nil)
end

_99.setup({
	provider = GitHubCopilotProvider,
	model = "gpt-5.4-mini",
})

vim.keymap.set("v", ",f", function()
	_99.visual()
end)

--- if you have a request you dont want to make any changes, just cancel it
vim.keymap.set("n", ",fx", function()
	_99.stop_all_requests()
end)

vim.keymap.set("n", ",fs", function()
	_99.search()
end)

vim.keymap.set("n", ",fm", function()
	require("99.extensions.telescope").select_model()
end)
