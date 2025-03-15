function check_dir(path)
	local ok, _ = pcall(vim.uv.fs_open, path)
	if not ok then
		vim.fn.mkdir(path, "p")
		return false
	end
	return true
end

function pull(opts)
	local ok = pcall(vim.fn.system, {
		"git",
		"-C",
		opts.playdate_luacats_clone,
		"pull",
		"--rebase",
	})

	if not ok or vim.v.shell_error ~= 0 then
		vim.notify("Failed to pull " .. opts.playdate_luacats_repo, vim.log.levels.ERROR)
		return false
	end

	return true
end

function clone(opts)
	check_dir()

	local ok = pcall(vim.fn.system, {
		"git",
		"clone",
		"--depth=1",
		opts.playdate_luacats_repo,
		opts.playdate_luacats_clone,
	})

	if not ok or vim.v.shell_error ~= 0 then
		vim.notify("Failed to clone " .. opts.playdate_luacats_repo, vim.log.levels.ERROR)
		return false
	end
end

local M = {}

--- @param opts Config
function M.setup(opts)
	if check_dir(opts.playdate_luacats_clone) then
		pull(opts)
	else
		clone(opts)
	end
end

return M
