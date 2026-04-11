-- lua/plugins/cpp.lua
-- C++ extras for openFrameworks and JUCE.
-- LazyVim's lang.clangd + lang.cmake extras cover the basics
-- (clangd LSP, cmake LSP, treesitter c/cpp/cmake, compile_commands.json).
-- These plugins add CMake build/run/debug, treesitter-based code generation,
-- and LLDB debugger installation via Mason.

return {
  -- CMake build/run/debug + compile_commands.json symlink to project root.
  -- Essential for JUCE (juce_add_plugin CMake API) and any non-default
  -- openFrameworks workflow that generates compile_commands via Bear/CMake.
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "cmake" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      cmake_build_directory = "build/${variant:buildType}",
      cmake_soft_link_compile_commands = true,
      cmake_build_options = {},
      cmake_variants_message = {
        short = { show = true },
        long  = { show = true, max_length = 40 },
      },
    },
    keys = {
      { "<leader>cm", "<cmd>CMakeGenerate<cr>", desc = "CMake generate" },
      { "<leader>cb", "<cmd>CMakeBuild<cr>",    desc = "CMake build" },
      { "<leader>cr", "<cmd>CMakeRun<cr>",      desc = "CMake run" },
      { "<leader>cd", "<cmd>CMakeDebug<cr>",    desc = "CMake debug (needs DAP)" },
      { "<leader>ct", "<cmd>CMakeSelectBuildTarget<cr>", desc = "CMake select target" },
    },
  },

  -- Generate class implementations, concrete override stubs,
  -- rule-of-5 boilerplate from treesitter AST.
  {
    "Badhi/nvim-treesitter-cpp-tools",
    ft = { "cpp", "hpp", "cxx", "h" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      preview = { quit = "q", accept = "<tab>" },
      header_extension = "h",
      source_extension = "cpp",
      custom_define_class_function_commands = {},
    },
    keys = {
      { "<leader>ci", "<cmd>TSCppDefineClassFunc<cr>", desc = "Implement class function" },
      { "<leader>co", "<cmd>TSCppMakeConcreteClass<cr>", desc = "Make concrete (impl virtuals)" },
      { "<leader>c5", "<cmd>TSCppRuleOf5<cr>", desc = "Generate Rule of 5" },
    },
  },

  -- codelldb via Mason — LLDB-based debugger for VST host attach
  -- (AudioPluginHost / REAPER / Ableton) and plain C++ debugging.
  -- Requires lazyvim.plugins.extras.dap.core to be enabled (it is).
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = { "codelldb" },
      automatic_installation = true,
      handlers = {},
    },
  },

  -- Stateful build/run/debug task runner with CMake File-API support.
  -- Good for per-project JUCE plugin host launch configs
  -- (e.g. "Launch AudioPluginHost with my VST loaded").
  {
    "Shatur/neovim-tasks",
    cmd = { "Task" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      params_file = ".nvim-tasks.json",
      default_params = {
        cmake = {
          cmd = "cmake",
          build_type = "Debug",
          build_dir = "build",
          configure_args = { "-G", "Ninja", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
        },
      },
    },
    keys = {
      { "<leader>cT", "<cmd>Task start<cr>", desc = "Task: run" },
    },
  },
}
