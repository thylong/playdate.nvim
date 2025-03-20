local Config = require "playdate.config"
local Util = require "playdate.util"

local M = {}

function M.setup()
	if Config.playdate_sdk_path == nil then
		Util.notify("playdate_sdk_path is not set.", vim.log.levels.ERROR)
		return
	end

	if not vim.uv.fs_stat(Config.playdate_sdk_path) then
		Util.notify("playdate_sdk_path is not valid.", vim.log.levels.ERROR)
	end

	if Config.playdate_luacats_path ~= nil then
		if not vim.uv.fs_stat(Config.playdate_luacats_path) then
			Util.notify("playdate_luacats_path is not valid, ignoring", vim.log.levels.WARN)
			Config.playdate_luacats_path = nil
		end
	end

	if not vim.uv.fs_stat(Config.build.source_dir) then
		Util.notify("Source dir not found.", vim.log.levels.WARN)
	end

	require("lspconfig").lua_ls.setup({ settings = Config.server_settings })
	vim.g.playdate_ready = true
end

return M
