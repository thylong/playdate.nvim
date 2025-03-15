local M = {}

--- @class Config
M.defaults = {
	playdate_sdk_path = vim.env.PLAYDATE_SDK_PATH,
	playdate_luacats_clone = vim.fn.stdpath("data") .. "playdate/playdate-luacats",
	playdate_luacats_remote = "https://github.com/notpeter/playdate-luacats",
}

--- @param opts? Config
function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

	if M.options.playdate_sdk_path == nil then
		error(
			"Playdate SDK path is not set. You must set the PLAYDATE_SDK_PATH environment variable, or set the playdate_sdk_path option in the plugin configuration.",
			vim.log.levels.ERROR
		)
	end
end

return M
