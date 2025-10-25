return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      require("snacks").setup(opts)
      vim.api.nvim_create_user_command("Notifications", function()
        Snacks.notifier.show_history()
      end, { desc = "Show notification history" })
    end,
    opts = {
      image = { enabled = true },
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = {
        enabled = false,
        hidden = true
      },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true, top_down = true, },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
      { "<D-S-f>",         function() Snacks.picker.grep() end,                  desc = "Grep" },
      { "<leader>:",       function() Snacks.picker.command_history() end,       desc = "Command History" },
      -- LSP
      { "gd",              function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
      { "grr",             function() Snacks.picker.lsp_references() end,        nowait = true,                  desc = "References" },
      { "gri",             function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
      { "gy",              function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
      { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
      { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- Other
      { "<leader>.",       function() Snacks.scratch() end,                      desc = "Toggle Scratch Buffer" },
      { "<leader>S",       function() Snacks.scratch.select() end,               desc = "Select Scratch Buffer" },
      { "<c-`>",           function() Snacks.terminal() end,                     desc = "Toggle Terminal",       mode = { "n", "v", "t" } },
      { "]]",              function() Snacks.words.jump(vim.v.count1) end,       desc = "Next Reference",        mode = { "n", "t" } },
      { "[[",              function() Snacks.words.jump(-vim.v.count1) end,      desc = "Prev Reference",        mode = { "n", "t" } },
    }
  },
}
