local Config = require("playdate.config")

local M = {}

function M.setup()
	require("lspconfig").lua_ls.setup({ settings = Config.server_settings })
	vim.g.playdate_ready = true
end

return M
