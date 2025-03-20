local M = {}

function M.notify(msg, level)
	vim.notify_once(msg, level, { title = "playdate.nvim" })
end

return M
