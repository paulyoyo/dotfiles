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
            ignored = false, -- hide gitignored by default
            -- Force-show common dev files even when gitignored:
            include = { ".env", ".env.*", ".env.local" },
          },
          files = {
            hidden = true,
            ignored = false,
            include = { ".env", ".env.*", ".env.local" },
          },
        },
      },
    },
  },
}
