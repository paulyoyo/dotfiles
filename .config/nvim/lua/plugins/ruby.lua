-- lua/plugins/ruby.lua
-- Rails extras on top of LazyVim's lang.ruby extra (ruby-lsp + ERB
-- treesitter + neotest-rspec + nvim-dap-ruby).

return {
  -- The gold standard for Rails navigation. Still maintained, still
  -- unmatched for :Emodel, :Econtroller, :A alternate-file, partial
  -- extraction, and path-aware gf for routes.
  {
    "tpope/vim-rails",
    ft = { "ruby", "eruby" },
    cmd = {
      "Rails", "Emodel", "Econtroller", "Eview", "Emigration", "Espec",
      "Ehelper", "Einitializer", "Elib", "Emailer", "Etask", "Etest",
      "A", "AV", "AS", "AT", "AD", "AE",
    },
  },

  -- Modern Rails companion: routes viewer, generators popup, DB
  -- console, test/rake task UI via nui.nvim.
  {
    "weizheheng/ror.nvim",
    ft = { "ruby", "eruby" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Ror" },
    keys = {
      { "<leader>rR", "<cmd>Ror<cr>",             desc = "Ror menu" },
      { "<leader>rr", "<cmd>Ror routes list<cr>", desc = "Ror routes list" },
      { "<leader>rg", "<cmd>Ror generators<cr>",  desc = "Ror generators" },
      { "<leader>rd", "<cmd>Ror db<cr>",          desc = "Ror DB console" },
    },
  },

  -- :Bopen <gem> to jump into gem source; Gemfile.lock awareness for gf.
  {
    "tpope/vim-bundler",
    ft = { "ruby", "eruby" },
    cmd = { "Bundle", "Bopen", "Bsplit", "Btabedit" },
  },

  -- :Rake task runner + non-Rails Ruby project navigation.
  {
    "tpope/vim-rake",
    ft = { "ruby" },
    cmd = { "Rake" },
  },
}
