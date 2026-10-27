-- lua/plugins/rails.lua
-- tpope's Rails navigation. Minitest runs through vim-rails too:
--   :Rails         run the current test file
--   :.Rails        run the test under the cursor
--   :A / :R        alternate / related file (model <-> test, controller <-> view)
--   :Emodel, :Econtroller, :Eview, :Emigration, :Etest ...
--   gf             path-aware: partials, routes, assets, constants
--   :Bopen <gem>   jump into a gem's source (vim-bundler)

return {
  {
    "tpope/vim-rails",
    lazy = false, -- detects the Rails root on BufEnter; cheap to load always
  },
  {
    "tpope/vim-bundler",
    lazy = false,
  },
}
