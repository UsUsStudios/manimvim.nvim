local M = {}

local core = require("manimvim.core")

function M.setup()
	vim.api.nvim_create_user_command("Manim", function()
		core.run()
	end, {})
end

return M
