-- coder/claudecode.nvim — Anthropic Claude Code integration
--
-- snacks.nvim is only declared as a dep; LazyVim already ships its spec.
-- terminal_cmd hardcoded because `claude` is nvm-managed at a path with
-- spaces (/Volumes/El Gato/External Mac/.nvm/…) and a headless / GUI
-- Neovim won't reliably inherit that on $PATH.

return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
    },
    opts = {
      -- snacks.terminal shell-splits cmd on spaces, so nvm's real path
      -- (/Volumes/El Gato/…) breaks. Use no-space symlink at
      -- /opt/homebrew/bin/claude-cli → real binary.
      terminal_cmd = "/opt/homebrew/bin/claude-cli",
      terminal = {
        provider = "snacks",
        split_side = "right",
        split_width_percentage = 0.35,
      },
      diff_opts = {
        layout = "vertical",
      },
    },
    keys = {
      { "<leader>a",  nil,                              desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v", desc = "Send selection to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file (explorer)",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
      },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    },
  },

  -- which-key group label
  {
    "folke/which-key.nvim",
    optional = true,
    opts = { spec = { { "<leader>a", group = "AI/Claude", icon = { icon = "󰚩", color = "orange" } } } },
  },
}
