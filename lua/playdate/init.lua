local Config = require "playdate.config"
local Util = require "playdate.util"

function is_playdate_project()
	return vim.uv.fs_stat(vim.fs.joinpath(Config.build.source_dir, "pdxinfo"))
end

local M = {}

---@param opts? playdate.Config
function M.setup(opts)
	Config.setup(opts)

	if is_playdate_project() then
		Util.notify("🟨 Detected Playdate project", vim.log.levels.INFO)

		local ok, err = pcall(require("playdate.lspconfig").setup)
		if not ok then
			Util.notify(err, vim.log.levels.ERROR)
		end
	end
end

return M
