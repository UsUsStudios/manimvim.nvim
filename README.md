# manimvim.nvim

Run a Manim scene easily through Neovim.

## Installation

```lua
-- using packer.nvim
use {
    "ususstudios/manimvim.nvim"
}

-- using lazy.nvim
{
    "ususstudios/manimvim.nvim",
    opts = {}
}
```

## Usage

Use `:Manim [quality]` or the keymap `<leader>mm` and then select the scene you would like to render.
The `[quality]` can be l (low), m (medium), h (high), p (2k) or k (4k).

## Configuration

```lua
require("manimvim").setup({
	keymaps = {
		enable = true, -- whether to automatically set keymaps
		render = "<leader>mm", -- what the keymap for rendering should be
	},
	rendering = {
		quality = "m", -- default render quality. l: low, m: medium, h: high, p: 2k, k: 4k
		play = true, -- whether to play the video after rendering
	}
})
```

## Contribution
Feel free to make a pull request.
