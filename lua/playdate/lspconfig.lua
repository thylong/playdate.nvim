local Config = require("playdate.config")

local M = {}

function M.setup()
	if Config.playdate_sdk_path == nil then
		local msg =
			"PLAYDATE_SDK_PATH is not set. Set it or set the playdate_sdk_path option in the plugin configuration."
		vim.notify_once(msg, vim.log.levels.ERROR, { title = "playdate.nvim" })
		error(msg)
		return
	end

	require("lspconfig").lua_ls.setup({ settings = Config.server_settings })
	vim.g.playdate_ready = true
end

return M
