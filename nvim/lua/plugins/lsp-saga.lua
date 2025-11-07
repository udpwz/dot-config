return {
  {
    'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    config = function()
      require('lspsaga').setup({
        ui = {
          border = 'rounded',
          devicon = true,
          title = true,
          expand = '󰜄',
          collapse = '󰛲',
          code_action = '',
          actionfix = '',
          lines = { '╰', '├', '│', '─' },
          kind = {},
          imp_sign = '󰳛 ',
        },
        symbol_in_winbar = {
          enable = true,
          separator = '› ',
          hide_keyword = false,
          show_file = true,
          folder_level = 2,
        },
        callhierarchy = {
          keys = {
            edit = '<cr>',
            vsplit = 'v',
            split = 's',
            tabe = 't',
            shuttle = '<C-w>',
            toggle_or_req = 'u',
            quit = { 'q', 'ESC' },
          }
        },
        code_action = {
          num_shortcut = true,
          show_server_name = true,
          extend_gitsigns = true,
          keys = {
            quit = 'q',
            exec = '<cr>',
          },
        },
        diagnostic = {
          show_code_action = true,
          show_source = true,
          jump_num_shortcut = true,
          max_width = 0.7,
          max_height = 0.6,
          text_hl_follow = false,
          border_follow = true,
          extend_relatedInformation = false,
          keys = {
            exec_action = 'e',
            quit = 'q',
            expand_or_jump = '<cr>',
            quit_in_show = { 'q', '<ESC>' },
          },
        },
        finder = {
          max_height = 0.5,
          min_width = 30,
          force_max_height = false,
          keys = {
            shuttle = '<C-w>',
            toggle_or_open = '<cr>',
            vsplit = 'v',
            split = 's',
            tabnew = 't',
            quit = { 'q', '<ESC>' },
            close = '<ESC>',
          },
        },
        symbols_in_winbar = {
          enable = true,
          sign = true,
          virtual_text = true,
          priority = 100
        },
        lightbulb = {
          enable = true,
          sign = true,
          virtual_text = false,
        },
        outline = {
          win_position = 'right',
          win_width = 30,
          auto_preview = true,
          auto_close = true,
          close_after_jump = false,
          layout = 'float',
          max_height = 0.5,
          left_width = 0.3,
          keys = {
            toggle_or_jump = '<cr>',
            quit = {'q', '<ESC>'},
            jump = 'e',
          },
        },
        rename = {
          in_select = true,
          auto_save = false,
          keys = {
            quit = 'q',
            exec = '<cr>',
            select = '<ESC>',
          },
        },
        beacon = {
          enable = true,
          frequency = 7,
        },
      })

      -- Keybindings
      local keymap = vim.keymap.set

      -- Lsp finder - Find the symbol's definition
      keymap('n', 'gh', '<cmd>Lspsaga finder tyd+ref+imp+def<CR>')

      -- Code action
      keymap({ 'n', 'v' }, '<leader>ca', '<cmd>Lspsaga code_action<CR>')

      -- Rename all occurrences of the hovered word for the entire file
      keymap('n', 'grr', '<cmd>Lspsaga rename<CR>')

      -- Rename all occurrences of the hovered word for the selected files
      keymap('n', 'grp', '<cmd>Lspsaga rename ++project<CR>')

      -- Peek definition
      keymap('n', 'gd', '<cmd>Lspsaga peek_definition<CR>')

      -- Go to definition
      keymap('n', 'gD', '<cmd>Lspsaga goto_definition<CR>')

      -- Peek type definition
      keymap('n', 'gy', '<cmd>Lspsaga peek_type_definition<CR>')

      -- Go to type definition
      keymap('n', 'gY', '<cmd>Lspsaga goto_type_definition<CR>')

      -- Toggle outline
      keymap('n', '<leader>o', '<cmd>Lspsaga outline<CR>')

      -- Hover Doc
      keymap('n', 'K', '<cmd>Lspsaga hover_doc<CR>')

      -- Callhierarchy
      keymap('n', '<Leader>icc', '<cmd>Lspsaga incoming_calls<CR>')
      keymap('n', '<Leader>occ', '<cmd>Lspsaga outgoing_calls<CR>')

      -- Custom command for workspace diagnostics
      vim.api.nvim_create_user_command('Diagnostics', 'Lspsaga show_workspace_diagnostics', {})

    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    }
  }
}
