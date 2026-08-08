-- NickvanDyke/opencode.nvim — OpenCode integration
--
-- snacks.nvim declared as dep only (LazyVim provides). Server is started
-- via `opencode --port` (required flag) in a snacks.terminal on the right
-- that does not steal focus. <C-a>/<C-x> from the README are intentionally
-- NOT bound — those are Vim's built-in increment/decrement.
--
-- User's ~/.config/opencode auth is untouched — plugin only spawns the
-- CLI already on $PATH.

local opencode_cmd = "opencode --port"

---@type snacks.terminal.Opts
local snacks_terminal_opts = {
  win = { position = "right", enter = false },
}

local function opencode() return require("opencode") end

return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = { "folke/snacks.nvim" },
    version = "*",
    init = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
          end,
        },
      }
    end,
    keys = {
      { "<leader>o",  nil,                                                    desc = "AI/OpenCode" },
      { "<leader>oa", function() opencode().ask("@this: ") end,               mode = { "n", "x" }, desc = "Ask about @this" },
      { "<leader>ob", function() opencode().ask("@buffer: ") end,             desc = "Ask about @buffer" },
      { "<leader>od", function() opencode().prompt("Fix @diagnostics") end,   desc = "Fix @diagnostics" },
      { "<leader>os", function() opencode().select() end,                     desc = "Select prompt" },
      { "<leader>on", function() opencode().command("session.new") end,       desc = "New session" },
      { "<leader>oi", function() opencode().command("session.interrupt") end, desc = "Interrupt session" },
      { "<leader>ou", function() opencode().command("session.undo") end,      desc = "Undo session" },
      -- Operator: `go{motion}` appends the range, `goo` operates on the line.
      { "go",  function() return opencode().operator("@this ") end,        mode = { "n", "x" }, expr = true, desc = "Append range to OpenCode" },
      { "goo", function() return opencode().operator("@this ") .. "_" end, expr = true,                       desc = "Append line to OpenCode" },
      -- Toggle terminal (README warning: keep <leader>-free so terminal-mode
      -- typing doesn't wait for a leader-sequence).
      {
        "<C-.>",
        function() require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts) end,
        mode = { "n", "t" },
        desc = "Toggle OpenCode terminal",
      },
    },
  },

  -- Enable snacks.input for Ask and snacks.picker for Select.
  {
    "folke/snacks.nvim",
    opts = {
      input = { enabled = true },
      picker = { enabled = true },
    },
  },

  -- blink.cmp LSP source for the Ask filetype so @-placeholders autocomplete.
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        per_filetype = {
          opencode_ask = { "lsp", "buffer" },
        },
      },
    },
  },

  -- which-key group label
  {
    "folke/which-key.nvim",
    optional = true,
    opts = { spec = { { "<leader>o", group = "AI/OpenCode", icon = { icon = "󰭹", color = "cyan" } } } },
  },
}
