-- lua/plugins/claude.lua
-- coder/claudecode.nvim with Neovim's native terminal (no snacks.nvim).
-- terminal_cmd points to a no-space symlink because `claude` lives under
-- nvm at a path with spaces (/Volumes/El Gato/External Mac/.nvm/...).

return {
  {
    "coder/claudecode.nvim",
    cmd = {
      "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeAdd", "ClaudeCodeSend",
      "ClaudeCodeTreeAdd", "ClaudeCodeStatus", "ClaudeCodeStart", "ClaudeCodeStop",
      "ClaudeCodeOpen", "ClaudeCodeClose", "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny",
    },
    opts = {
      terminal_cmd = "/opt/homebrew/bin/claude-cli",
      terminal = {
        provider = "native",
        split_side = "right",
        split_width_percentage = 0.35,
      },
      diff_opts = { layout = "vertical" },
    },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
