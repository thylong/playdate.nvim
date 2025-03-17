local Config = require("playdate.config")

local M = {}

--- @param run? fun(chan: integer)
function M.build(run)
	if not vim.g.playdate_ready then
		vim.notify("Not ready. Try running :PlaydateSetup first.", vim.log.levels.WARN, { title = "playdate.nvim" })
		return
	end

	local pdc = vim.fs.joinpath(Config.playdate_sdk_path, "/bin/pdc")

	-- open terminal window
	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_open_win(buf, false, { split = "below" })
	local chan = vim.api.nvim_open_term(buf, {})

	-- call build cmd
	vim.system(
		{ pdc, Config.build.source_dir, Config.build.output_dir, "out.pdx" },
		{
			text = true,
			stdout = false,
			stderr = vim.schedule_wrap(function(err, data)
				assert(not err, err)
				if data and type(data) == "string" then
					vim.api.nvim_chan_send(chan, data)
				end
			end),
		},
		vim.schedule_wrap(function(out)
			if out.code ~= 0 then
				vim.notify("Failed to build project", vim.log.levels.ERROR, { title = "playdate.nvim" })
				return
			end

			vim.notify("Build successful 🎉", nil, { title = "playdate.nvim" })
			if run ~= nil then
				run(chan)
			end
		end)
	)
end

function M.run()
	local playdate_simulator = vim.fs.joinpath(Config.playdate_sdk_path, "/bin/PlaydateSimulator")

	M.build(function(chan)
		vim.system({ playdate_simulator, Config.build.output_dir, "out.pdx" }, {
			text = true,
			stdout = vim.schedule_wrap(function(err, data)
				assert(not err, err)
				if data and type(data) == "string" then
					vim.api.nvim_chan_send(chan, data)
				end
			end),
			stderr = vim.schedule_wrap(function(err, data)
				assert(not err, err)
				if data and type(data) == "string" then
					vim.api.nvim_chan_send(chan, data)
				end
			end),
		}, function(out)
			if out.code ~= 0 then
				vim.notify(
					"Playdate Simulator exited with error code" .. out.code,
					vim.log.levels.ERROR,
					{ title = "playdate.nvim" }
				)
			end
		end)
	end)
end

return M
