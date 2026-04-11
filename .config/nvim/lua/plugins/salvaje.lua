-- lua/plugins/salvaje.lua
-- Wire LazyVim to use the Salvaje colorscheme defined at
-- ~/.config/nvim/colors/salvaje.lua (standard Neovim colorscheme path).
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "salvaje",
    },
  },
}
