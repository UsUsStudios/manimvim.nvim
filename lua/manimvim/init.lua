local M = {}

M.defaults = {
	keymaps = {
		enable = true, -- whether to automatically set keymaps
		render = "<leader>mm", -- what the keymap for rendering should be
	},
	rendering = {
		quality = "m", -- default render quality. l: low, m: medium, h: high, p: 2k, k: 4k
		play = true, -- whether to play the video after rendering
	},
}

M.config = {}

M.keymap_registry = {}

local core = require("manimvim.core")

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.defaults, opts or {})

	M.setup_commands()
	M.clear_keymaps()
	if M.config.keymaps.enable then
		M.setup_keymaps()
	end
end

function M.setup_commands()
	vim.api.nvim_create_user_command("Manim", function(opts)
		if opts.args then
			core.render(opts.args, M.config.rendering.play)
		else
			core.render_no_args(M.config.rendering.play)
		end
	end, { nargs = "?" })
end

function M.clear_keymaps()
	for _, keymap in ipairs(M.keymap_registry) do
		vim.keymap.del(keymap.mode, keymap.rhs, keymap.opts)
	end
	M.created_keymaps = {}
end

function M.setup_keymaps()
	M.set_keymap("n", M.config.keymaps.render, ":Manim " .. M.config.rendering.quality .. "<CR>", {})
end

function M.set_keymap(mode, lhs, rhs, opts)
	opts = opts or {}

	-- Generate a unique ID for this keymap
	local id = mode .. ":" .. lhs

	-- If this keymap already exists, delete it first
	if M.keymap_registry[id] then
		pcall(vim.keymap.del, mode, lhs)
	end

	-- Set the new keymap
	vim.keymap.set(mode, lhs, rhs, opts)

	-- Store in registry
	M.keymap_registry = { mode = mode, lhs = lhs, opts = opts }
end

return M
