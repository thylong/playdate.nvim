local M = {}

function M.notify(msg, level)
	vim.notify(msg, level, { title = "playdate.nvim" })
end

return M
