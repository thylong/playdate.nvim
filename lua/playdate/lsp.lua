local M = {}

function exists(file)
	local f = io.open(file, "r")
	return f ~= nil and io.close(f)
end

function M.is_playdate_project()
	return exists(vim.fn.getcwd() .. "pdxinfo")
end

--- @param opts Config
function M.setup(opts)
	local lspconfig = require("lspconfig")

	lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(config)
		if config.name == "lua_ls" then
			config.settings = vim.tbl_deep_extend("force", config.settings, {
				Lua = {
					diagnostics = {
						globals = { "import" },
						disable = { "lowercase-global" },
						severity = {
							["duplicate-set-field"] = "Hint",
						},
					},
					workspace = {
						library = {
							opts.playdate_sdk_path,
							opts.playdate_luacats_clone,
						},
					},
					runtime = {
						builtin = {
							io = "disable",
							os = "disable",
							package = "disable",
						},
						special = { import = "require" },
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
					},
					completion = {
						requireSeparator = "/",
					},
				},
			})
		end
	end)
end

return M
