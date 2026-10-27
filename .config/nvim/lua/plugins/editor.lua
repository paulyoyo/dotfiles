-- lua/plugins/editor.lua
-- Core editing: syntax (treesitter), fuzzy finding, git signs, surround.

local parsers = {
  -- Rails
  "ruby", "embedded_template", "html", "css", "yaml", "sql",
  -- JavaScript
  "javascript", "jsdoc", "json",
  -- C++ / shaders (JUCE + Salvaje)
  "c", "cpp", "cmake", "glsl",
  -- General
  "lua", "vim", "vimdoc", "query", "bash", "markdown", "markdown_inline", "diff", "gitcommit",
}

return {
  -- nvim-treesitter (main branch): installs parsers only; highlighting is
  -- started per buffer with the built-in vim.treesitter.start().
  -- Needs the `tree-sitter` CLI on PATH (brew install tree-sitter-cli).
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(parsers)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("paul_treesitter", { clear = true }),
        callback = function(args) pcall(vim.treesitter.start, args.buf) end,
      })
    end,
  },

  -- fzf-lua: uses the fzf/fd/rg already installed for the shell.
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      fzf_colors = true, -- derive colors from the Salvaje colorscheme
      winopts = { height = 0.85, width = 0.85, preview = { layout = "vertical" } },
      files = { hidden = true },
    },
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
      { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Grep word under cursor" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
      { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
      { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Help" },
      { "<leader>fr", "<cmd>FzfLua resume<cr>", desc = "Resume last picker" },
      { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostics" },
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git status" },
    },
  },

  -- File-type icons for fzf-lua (Nerd Font glyphs via kitty symbol_map).
  {
    "echasnovski/mini.icons",
    lazy = true,
    config = function()
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
    end,
  },

  -- Git hunks in the sign column.
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function bmap(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
        end
        bmap("]h", function() gs.nav_hunk("next") end, "Next hunk")
        bmap("[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        bmap("<leader>hp", gs.preview_hunk, "Preview hunk")
        bmap("<leader>hr", gs.reset_hunk, "Reset hunk")
        bmap("<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
      end,
    },
  },

  -- File tree pinned on the left, opened on every startup.
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      view = { side = "left", width = 32 },
      filters = { dotfiles = false, git_ignored = false },
      update_focused_file = { enable = true },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      local api = require("nvim-tree.api")
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function() api.tree.open({ focus = false }) end,
      })
      -- Quit nvim when the tree is the only window left.
      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          local wins = vim.tbl_filter(function(w)
            return vim.api.nvim_win_get_config(w).relative == ""
          end, vim.api.nvim_list_wins())
          if #wins == 2 and api.tree.is_visible() then vim.cmd("NvimTreeClose") end
        end,
      })
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
  },

  -- Classic surround: ys{motion}{char}, cs{old}{new}, ds{char}.
  { "tpope/vim-surround", event = "VeryLazy" },
}
