local M = {}

--- @param opts Config
function M.setup(opts)
	local config = require("playdate.config")
	local luacats = require("playdate.luacats")
	local lsp = require("playdate.lsp")

	config.setup(opts)

	luacats.setup(opts)

	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			if lsp.is_playdate_project() then
				lsp.setup(opts)
			end
		end,
	})
end

return M
