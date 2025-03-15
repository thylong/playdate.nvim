-- Playdate-specific
if exists(vim.fn.getcwd() .. "pdxinfo") then
	vim.cmd("compiler pdc")
end
