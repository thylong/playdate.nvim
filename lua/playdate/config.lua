--- @class playdate.Config.mod: playdate.Config
local M = {}

--- @class playdate.Config
--- @field playdate_sdk_path string?
--- @field playdate_luacats_path string?
local defaults = {
	playdate_sdk_path = os.getenv "PLAYDATE_SDK_PATH",
	playdate_luacats_path = os.getenv "PLAYDATE_LUACATS_PATH",
	--- @class playdate.Config.build
	build = {
		source_dir = "src",
		output_dir = "build.pdx",
	},
	server_settings = {
		Lua = {
			completion = {
				requireSeparator = "/",
			},
			diagnostics = {
				disable = { "lowercase-global" },
				severity = {
					["duplicate-set-field"] = "Hint",
				},
			},
			runtime = {
				builtin = {
					io = "disable",
					os = "disable",
					package = "disable",
				},
				nonstandardSymbol = {
					"+=",
					"-=",
					"*=",
					"/=",
					"//=",
					"%=",
					"<<=",
					">>=",
					"&=",
					"|=",
					"^=",
				},
				special = { import = "require" },
			},
		},
	},
}

--- @type playdate.Config
local options

--- @param opts? playdate.Config
function M.setup(opts)
	options = vim.tbl_deep_extend("force", {}, defaults, opts or {})

	if options.playdate_sdk_path ~= nil then
		options.playdate_sdk_path = vim.fs.normalize(options.playdate_sdk_path)
	end

	if options.playdate_luacats_path ~= nil then
		options.playdate_luacats_path = vim.fs.normalize(options.playdate_luacats_path)
	end

	options.build = {
		source_dir = vim.fs.joinpath(vim.uv.cwd() or ".", options.build.source_dir),
		output_dir = vim.fs.joinpath(vim.uv.cwd() or ".", options.build.output_dir),
	}

	options.server_settings = vim.tbl_deep_extend("force", options.server_settings, {
		Lua = {
			workspace = {
				library = {
					options.playdate_sdk_path,
					options.playdate_luacats_path,
				},
			},
		},
	})

	vim.api.nvim_create_user_command("PlaydateSetup", function()
		require("playdate.lspconfig").setup()
	end, { desc = "Setup lua_ls for Playdate" })

	vim.api.nvim_create_user_command("PlaydateBuild", function(opts)
		require("playdate.compile").build(opts.fargs[1], opts.fargs[2])
	end, { desc = "Compile a project with `pdc`", nargs = "*" })

	vim.api.nvim_create_user_command("PlaydateBuildRun", function(opts)
		require("playdate.compile").build_and_run(opts.fargs[1], opts.fargs[2])
	end, { desc = "Compile and run a project in the Playdate simulator", nargs = "*" })

	vim.api.nvim_create_user_command("PlaydateRun", function(opts)
		require("playdate.compile").run(opts.fargs[1])
	end, { desc = "Run a compiled project in the Playdate simulator", nargs = "?" })

	return options
end

return setmetatable(M, {
	__index = function(_, key)
		options = options or M.setup()
		return options[key]
	end,
})
