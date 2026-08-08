-- GLSL support: filetype detection + treesitter parser + glsl_analyzer LSP.
-- glsl_analyzer binary installed via mason (was missing on this system).

vim.filetype.add({
  extension = {
    glsl = "glsl",
    vert = "glsl",
    frag = "glsl",
  },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "glsl" })
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "glsl_analyzer" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        glsl_analyzer = {},
      },
    },
  },
}
