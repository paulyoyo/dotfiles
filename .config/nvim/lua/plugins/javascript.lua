-- lua/plugins/javascript.lua
-- JS/TS extras for Next.js, Gatsby, and any React-based stack.
-- Sits on top of LazyVim's lang.typescript + lang.tailwind +
-- formatting.prettier + linting.eslint extras.
--
-- NOTE: lang.typescript defaults to vtsls. typescript-tools.nvim is a
-- faster alternative for large Next.js monorepos. Don't enable both at
-- the same time — pick one. This file enables typescript-tools and
-- disables vtsls; flip the booleans if you prefer vtsls.

return {
  -- Faster TS LSP wrapper (direct tsserver protocol, skips vtsls).
  -- "add missing imports", "organize imports", "remove unused", async
  -- file rename handling. Noticeably faster than vtsls on monorepos.
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
          includeCompletionsForModuleExports = true,
          quotePreference = "auto",
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
        },
      },
    },
  },
  -- Disable vtsls from lang.typescript extra since typescript-tools
  -- replaces it. (Comment out these blocks if you want vtsls instead.)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = { enabled = false },
      },
    },
  },

  -- Tailwind class sorting, inline color preview, cva()/cn() pattern
  -- awareness. Critical for shadcn/ui + Next.js workflows.
  {
    "luckasRanarison/tailwind-tools.nvim",
    ft = {
      "html", "javascript", "javascriptreact",
      "typescript", "typescriptreact",
      "css", "mdx", "astro", "vue", "svelte", "eruby",
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    build = ":UpdateRemotePlugins",
    opts = {
      document_color = { enabled = true, kind = "inline" },
      conceal = { enabled = false },
      extension = {
        queries = {},
        patterns = {
          typescriptreact = { "cva%((.-)%)", "cn%((.-)%)" },
          javascriptreact = { "cva%((.-)%)", "cn%((.-)%)" },
        },
      },
    },
    cmd = { "TailwindSort", "TailwindSortSelection", "TailwindConcealEnable", "TailwindColorToggle" },
  },

  -- Rewrites 200-line TypeScript errors into plain English.
  -- Huge quality-of-life for RSC/Next's type magic.
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact" },
    opts = {},
  },

  -- Async project-wide `tsc --noEmit` into quickfix. Catches RSC
  -- server/client boundary errors that the in-buffer LSP misses.
  {
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    opts = {
      auto_open_qflist = true,
      flags = { build = true, noEmit = true },
    },
    keys = {
      { "<leader>tt", "<cmd>TSC<cr>", desc = "TSC full project check" },
    },
  },

  -- GraphQL filetype + gql`` tagged template highlighting inside JS/TS.
  -- Useful for Gatsby (data layer) and any Next.js app with GraphQL.
  {
    "jparise/vim-graphql",
    ft = {
      "graphql", "javascript", "javascriptreact",
      "typescript", "typescriptreact",
    },
  },

  -- Proper .mdx filetype + treesitter injection so JSX inside MDX
  -- highlights and folds correctly. Essential for Gatsby / Next.js
  -- content-heavy sites.
  {
    "davidmh/mdx.nvim",
    ft = { "mdx" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
  },

  -- 3rd/image.nvim (inline kitty image preview) is intentionally
  -- omitted — it requires luarocks/magick bindings that break the
  -- lazy.nvim install on this setup. Re-enable by adding the spec
  -- back and setting `rocks = { enabled = true }` in config/lazy.lua
  -- after you have a working luarocks + Lua 5.1 install.
}
