local Config = require("playdate.config")

local M = {}

function M.open_console()
	if M.chan ~= nil then
		return M.chan
	end

	-- open terminal window
	local buf = vim.api.nvim_create_buf(false, false)
	vim.api.nvim_open_win(buf, false, { split = "below" })
	local chan = vim.api.nvim_open_term(buf, {})

	vim.api.nvim_create_autocmd("BufDelete", {
		buffer = buf,
		callback = function()
			M.chan = nil
		end,
	})

	M.chan = chan
	return chan
end

---@param name string?
function M.output(name)
	return vim.fs.joinpath(Config.build.output_dir, (name or "out") .. ".pdx")
end

---@param name? string
function M.build(name)
	-- local chan = M.open_console()

	if not vim.g.playdate_ready then
		vim.notify("Not ready. Try running :PlaydateSetup first.", vim.log.levels.WARN, { title = "playdate.nvim" })
		return
	end

	local pdc = vim.fs.joinpath(Config.playdate_sdk_path, "/bin/pdc")

	if not vim.uv.fs_stat(Config.build.output_dir) then
		if not vim.fn.mkdir(Config.build.output_dir, "p") then
			vim.notify("Failed to create build directory", vim.log.levels.ERROR, { title = "playdate.nvim" })
			return
		end
	end

	-- call build cmd
	local obj = vim.system({ pdc, Config.build.source_dir, M.output(name) }, {
		text = true,
		stdout = false,
		stderr = false,
	}):wait()

	if obj.code ~= 0 then
		vim.notify("Failed to build project", vim.log.levels.ERROR, { title = "playdate.nvim" })
		return
	end

	vim.notify("Build successful 🎉", nil, { title = "playdate.nvim" })
end

---@param name string?
function M._run(name)
	if M.simulator_pid ~= nil then
		return
	end

	local playdate_simulator = vim.fs.joinpath(Config.playdate_sdk_path, "/bin/PlaydateSimulator")

	local out = vim.system({ playdate_simulator, M.output(name) }, {
		text = true,
		stdout = false,
		stderr = false,
	}, function(out)
		if out.code ~= 0 then
			vim.notify(
				"Playdate Simulator exited with error code" .. out.code,
				vim.log.levels.ERROR,
				{ title = "playdate.nvim" }
			)
		end
		M.simulator_pid = nil
	end)

	M.simulator_pid = out.pid
end

function M.run()
	M.build()
	M._run()
end

function M.run_only()
	M._run()
end

return M
