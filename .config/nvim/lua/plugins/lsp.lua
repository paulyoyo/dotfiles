-- lua/plugins/lsp.lua
-- Native Neovim LSP (0.11+). nvim-lspconfig only supplies server defaults;
-- servers are configured with vim.lsp.config() and started with
-- vim.lsp.enable(). Completion is Neovim's built-in LSP completion
-- (<C-n>/<C-p> to move, <C-y> to accept, <C-e> to dismiss).
--
-- Built-in LSP keymaps (Neovim 0.11 defaults, no config needed):
--   K     hover            grn  rename          gra  code action
--   grr   references       gri  implementation  gO   document symbols
--   [d ]d prev/next diagnostic   <C-s> (insert) signature help
-- Added below: gd definition, gD declaration.
--
-- One-time install of servers/formatters not provided by the system:
--   :MasonInstall typescript-language-server eslint-lsp
--                 tailwindcss-language-server glsl_analyzer prettier
-- ruby-lsp comes from the project's rbenv (never from mason, see below).
-- clangd comes from the Xcode Command Line Tools.

-- server name -> executable that must exist for it to be enabled
local servers = {
  -- ruby-lsp must NOT come from mason: its wrapper exports a mason GEM_PATH,
  -- and when ruby-lsp re-execs under the composed bundle bundler can't find
  -- the gem (exit 127). The rbenv shim respects .ruby-version and the bundle.
  ruby_lsp = "/opt/rbenv/shims/ruby-lsp",
  ts_ls = "typescript-language-server",
  eslint = "vscode-eslint-language-server",
  tailwindcss = "tailwindcss-language-server",
  clangd = "clangd",
  glsl_analyzer = "glsl_analyzer",
}

vim.filetype.add({ extension = { glsl = "glsl", vert = "glsl", frag = "glsl" } })

return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    lazy = false, -- must run early so its bin dir is on PATH before LSP starts
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      vim.lsp.config("ruby_lsp", { cmd = { servers.ruby_lsp } })

      for name, bin in pairs(servers) do
        if vim.fn.executable(bin) == 1 then vim.lsp.enable(name) end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("paul_lsp", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end
          local buf = args.buf

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buf, desc = "Go to declaration" })

          -- Prettier (via conform) owns JS formatting, not ts_ls.
          if client.name == "ts_ls" then
            client.server_capabilities.documentFormattingProvider = false
          end

          if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
          end
        end,
      })
    end,
  },

  -- Format on save. Ruby goes through ruby-lsp (rubocop / rubocop-rails-omakase
  -- from the project bundle). Prettier only runs when the project has its own
  -- prettier config, so importmap Rails apps don't get reformatted JS.
  -- Toggle for the session with :FormatToggle.
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo", "FormatToggle" },
    config = function()
      local js = { "prettier" }
      require("conform").setup({
        formatters_by_ft = {
          javascript = js, javascriptreact = js, json = js, css = js, scss = js,
        },
        formatters = { prettier = { require_cwd = true } },
        default_format_opts = { lsp_format = "fallback" },
        format_on_save = function()
          if vim.g.disable_autoformat then return end
          return { timeout_ms = 1500 }
        end,
      })
      vim.api.nvim_create_user_command("FormatToggle", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
      end, {})
    end,
    keys = {
      { "<leader>cf", function() require("conform").format() end, desc = "Format buffer" },
    },
  },
}
