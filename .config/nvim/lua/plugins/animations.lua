-- lua/plugins/animations.lua
-- Visual eye-candy on top of LazyVim:
--   1. sphamba/smear-cursor.nvim — comet-trail cursor effect
--   2. karb94/neoscroll.nvim     — smooth scrolling
--   3. folke/snacks.nvim (already installed) — enable indent animation

return {
  -- ── Smear cursor — trail effect when the cursor moves ───────────
  -- Uses Wisteria (Salvaje magenta) for the smear body so it blends
  -- with the Salvaje background.
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      -- Smear color — Wisteria (matches Salvaje palette)
      cursor_color = "#C599E2",
      -- Damping: lower = more persistent trail (0..1)
      stiffness = 0.6,
      trailing_stiffness = 0.4,
      stiffness_insert_mode = 0.5,
      trailing_stiffness_insert_mode = 0.3,
      -- Tail length
      distance_stop_animating = 0.1,
      -- Skip in insert mode changes to avoid flicker on autocomplete popups
      legacy_computing_symbols_support = false,
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      -- Hide the original block cursor during the smear animation
      hide_target_hack = false,
    },
  },

  -- ── Smooth scrolling — eases Ctrl-d/u, Ctrl-f/b, gg, G, zz ──────
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      local neoscroll = require("neoscroll")
      neoscroll.setup({
        mappings = {
          "<C-u>", "<C-d>",
          "<C-b>", "<C-f>",
          "<C-y>", "<C-e>",
          "zt", "zz", "zb",
        },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        duration_multiplier = 1.0,
        easing = "quadratic",
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
      })
    end,
  },

  -- ── snacks.nvim — enable indent animation (already installed) ───
  -- Overrides the LazyVim default opts to turn on the animated indent
  -- guide and bump the animation speed to match the rest of the setup.
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        enabled = true,
        animate = {
          enabled = true,
          style = "out",        -- "out" | "up_down" | "down" | "up"
          easing = "linear",
          duration = {
            step = 20,           -- ms per step
            total = 500,         -- ms total animation
          },
        },
        -- Indent guide color comes from the Salvaje colorscheme
        -- (IblIndent / IblScope are already mapped in colors/salvaje.lua)
      },
      scroll = {
        enabled = false, -- let neoscroll handle scrolling, not snacks
      },
    },
  },
}
