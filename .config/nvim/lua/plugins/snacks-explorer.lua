-- lua/plugins/snacks-explorer.lua
-- Show dotfiles (hidden files) in snacks.explorer and the file picker by
-- default. Gitignored files stay hidden — toggle them on demand with
-- Alt+I inside the explorer/picker.
--
-- Runtime toggles:
--   Alt+H   toggle hidden files (dotfiles)
--   Alt+I   toggle gitignored files

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,   -- show dotfiles by default
            ignored = false, -- still hide gitignored by default
          },
          files = {
            hidden = true,
            ignored = false,
          },
        },
      },
    },
  },
}
