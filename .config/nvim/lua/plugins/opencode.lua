-- NickvanDyke/opencode.nvim — OpenCode integration
-- snacks.nvim declared as dependency only (LazyVim already ships its spec).
-- <C-a>/<C-x> from the README are intentionally NOT bound — those are Vim's
-- built-in increment/decrement. User's own auth at ~/.config/opencode is
-- untouched; plugin only spawns the `opencode` CLI already on $PATH.

local function opencode() return require("opencode") end

return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = { "folke/snacks.nvim" },
    version = "*",
    keys = {
      { "<leader>o",  nil,                                                                       desc = "AI/OpenCode" },
      { "<leader>oa", function() opencode().ask("@this: ") end,                                  mode = { "n", "x" }, desc = "Ask about @this" },
      { "<leader>ob", function() opencode().ask("@buffer: ") end,                                desc = "Ask about @buffer" },
      { "<leader>od", function() opencode().prompt("Fix @diagnostics") end,                     desc = "Fix @diagnostics" },
      { "<leader>os", function() opencode().select() end,                                        desc = "Select prompt" },
      { "<leader>on", function() opencode().command("session.new") end,                         desc = "New session" },
      { "<leader>oi", function() opencode().command("session.interrupt") end,                   desc = "Interrupt session" },
      { "<leader>ou", function() opencode().command("session.undo") end,                        desc = "Undo session" },
      -- Operator: `go{motion}` appends the range, `goo` operates on the line.
      { "go",  function() return opencode().operator("@this ") end,        mode = { "n", "x" }, expr = true, desc = "Append range to OpenCode" },
      { "goo", function() return opencode().operator("@this ") .. "_" end, expr = true,                       desc = "Append line to OpenCode" },
      -- Toggle terminal (see README warning: no <leader> here so terminal-mode
      -- typing doesn't wait for a leader-sequence).
      {
        "<C-.>",
        function() require("snacks.terminal").toggle("opencode") end,
        mode = { "n", "t" },
        desc = "Toggle OpenCode terminal",
      },
    },
  },
}
