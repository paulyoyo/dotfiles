-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ── Line wrapping ───────────────────────────────────────────────────
-- LazyVim defaults to `wrap = false`, which makes long lines scroll
-- horizontally off-screen. Turn on soft-wrap that:
--   - wraps at the window edge (wrap)
--   - breaks at word boundaries instead of mid-word (linebreak)
--   - keeps the indentation of the original line on wrapped parts
--     (breakindent + showbreak prefix)
-- This is a pure-visual wrap — the file on disk is untouched, no
-- newlines inserted.
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↳ "

-- Toggle wrap on/off during the session with LazyVim's built-in:
--   <leader>uw
