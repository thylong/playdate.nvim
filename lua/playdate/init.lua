local Config = require("playdate.config")

function is_playdate_project()
	return vim.uv.fs_stat((vim.uv.cwd() or ".") .. "/pdxinfo") ~= nil
end

local M = {}

---@param opts? playdate.Config
function M.setup(opts)
	Config.setup(opts)

	if is_playdate_project() then
		vim.notify("Detected Playdate project", vim.log.levels.INFO, { title = "playdate.nvim" })
		require("playdate.lspconfig").setup()
	end
end

return M
