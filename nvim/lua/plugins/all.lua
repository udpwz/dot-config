return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ahmedkhalf/project.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "debugloop/telescope-undo.nvim",
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob', '!.git/*'
          },
        },
        pickers = {
          live_grep = {
            additional_args = function()
              return { "--hidden", "--glob", "!**/.git/*" }
            end,
          },
        },
        extensions = {
          fzf = {},
          frecency = {
            show_scores = true,
            show_unindexed = false,
            ignore_patterns = { "*.git/*", "*/tmp/*" },
          },
        },
      })
      telescope.load_extension("projects")

      local builtin = require("telescope.builtin")

      require("telescope").load_extension("fzf")

      vim.keymap.set("n", "<leader>fh", builtin.help_tags,
        { desc = "help_tags" })

      vim.keymap.set("n", "<leader>fc", function()
        require("telescope.builtin").find_files {
          cwd = vim.fn.stdpath("config")
        }
      end, { desc = "find_files.config" })

      vim.keymap.set("n", "<leader>fd", function()
        require("telescope.builtin").find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end, { desc = "find_files.data" })
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("project_nvim").setup({
        -- detect projects based on git root or LSP workspace
        detection_methods = { "lsp", "pattern" },
        -- patterns to identify project root
        patterns = { ".git", "package.json", "Makefile", "Jusfile" },
        -- don’t change your cwd automatically
        silent_chdir = true,
        -- scope: workspace (false) vs global (true)
        scope_chdir = nil,
      })
      -- register the extension with Telescope
      require("telescope").load_extension("projects")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-refactor",
    },
    build = ":TSUpdate",
    init = function()
      require("vim.treesitter.query").add_predicate("is-mise?",
        function(_, _, bufnr, _)
          local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
          local filename = vim.fn.fnamemodify(filepath, ":t")
          return string.match(filename, ".*mise.*%.toml$") ~= nil
        end, { force = true, all = false })
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        sync_install = true,
        highlight = { enable = true },
        refactor = {
          highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true,
          },
          highlight_current_scope = { enable = true },
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = "grn",
            }
          },
        }
      })
    end
  },
  {
    "folke/which-key.nvim",
    opts = {},
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },
}
