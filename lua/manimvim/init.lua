local M = {}

local core = require("manimvim.core")

function M.setup()
	vim.api.nvim_create_user_command("Manim", function()
		core.render()
	end, {})

	vim.api.nvim_set_keymap("n", "<leader>mm", ":Manim<CR>", {})
end

return M
