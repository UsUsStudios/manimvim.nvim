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

Use `:Manim` or the keymap `<leader>mm` and then select the scene you would like to render.

## Configuration

```lua
require("manimvim").setup({
	keymaps = {
		enable = true, -- whether to automatically set keymaps
		render = "<leader>mm", -- what the keymap for rendering should be
	}
})
```

## Contribution
Feel free to make a pull request.
