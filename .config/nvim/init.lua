-- ~/.config/nvim/init.lua
-- Minimal Neovim config focused on Rails + JavaScript.
-- No distro: plain Vim behaviour, native LSP completion, native cmdline.
-- Requires Neovim 0.11+ (vim.lsp.config / vim.lsp.enable, nvim-treesitter main).
--
-- Layout:
--   init.lua                 options, keymaps, autocmds, lazy.nvim bootstrap
--   lua/plugins/editor.lua   treesitter, fzf-lua, gitsigns, surround, icons
--   lua/plugins/lsp.lua      mason, LSP servers, conform (format on save)
--   lua/plugins/rails.lua    vim-rails, vim-bundler
--   lua/plugins/claude.lua   claudecode.nvim
--   colors/salvaje*.lua      Salvaje colorschemes

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ── Options ─────────────────────────────────────────────────────────
local o = vim.opt
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.termguicolors = true
o.mouse = "a"
o.clipboard = "unnamedplus"
o.undofile = true
o.swapfile = false
o.ignorecase = true
o.smartcase = true
o.inccommand = "split"
o.splitright = true
o.splitbelow = true
o.scrolloff = 4
o.updatetime = 250
o.timeoutlen = 400
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.completeopt = { "menuone", "noselect", "popup", "fuzzy" }
o.pumheight = 12

-- Soft wrap at word boundaries, keeping indentation (carried over).
o.wrap = true
o.linebreak = true
o.breakindent = true
o.showbreak = "↳ "

-- netrw: plain file browser via :Ex or "-"
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

-- ── Keymaps ─────────────────────────────────────────────────────────
local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("n", "-", "<cmd>Explore<cr>", { desc = "File browser (netrw)" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>D", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ── Autocmds ────────────────────────────────────────────────────────
local aug = vim.api.nvim_create_augroup("paul", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug,
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

-- Return to last cursor position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = aug,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  severity_sort = true,
  float = { border = "rounded" },
})

-- ── lazy.nvim bootstrap (plugin manager only, not LazyVim) ──────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "salvaje", "habamax" } },
  change_detection = { notify = false },
  rocks = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})

vim.cmd.colorscheme("salvaje")
