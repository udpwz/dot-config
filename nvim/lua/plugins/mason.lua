return {
  {
    'neovim/nvim-lspconfig',
  },
  {
    'mason-org/mason.nvim',
    opts = {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗'
        }
      }
    },
    config = function(_, opts)
      require('mason').setup(opts)
    end
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'lua_ls', 'ts_ls', 'rust_analyzer' }
    },
    dependencies = {
      { 'mason-org/mason.nvim' },
      'neovim/nvim-lspconfig',
    },
    config = function(_, opts)
      local mason_lspconfig = require('mason-lspconfig')

      -- Setup mason-lspconfig with handlers included
      mason_lspconfig.setup({
        ensure_installed = opts.ensure_installed,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,

          -- Custom handler for lua_ls
          ["lua_ls"] = function()
            require('lspconfig').lua_ls.setup({
              settings = {
                Lua = {
                  runtime = {
                    version = 'LuaJIT',
                  },
                  diagnostics = {
                    globals = { 'vim', 'Snacks' },
                    disable = { 'missing-fields' },
                  },
                  workspace = {
                    library = {
                      vim.env.VIMRUNTIME,
                      "${3rd}/luv/library",
                    },
                    checkThirdParty = false,
                  },
                  telemetry = {
                    enable = false,
                  },
                  completion = {
                    callSnippet = 'Replace',
                  },
                },
              },
            })
          end,
        }
      })
    end
  }
}
