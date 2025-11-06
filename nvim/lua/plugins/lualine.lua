local mode_map = {
  ['NORMAL'] = 'N',
  ['INSERT'] = 'I',
  ['VISUAL'] = 'V',
  ['V-LINE'] = 'VL',
  ['V-BLOCK'] = 'VB',
  ['REPLACE'] = 'R',
  ['COMMAND'] = 'C',
  ['TERMINAL'] = 'T',
}

local function short_status(mode)
  return mode_map[mode] or mode:sub(1, 1)
end

local function open_diagnostics_qf()
  vim.diagnostic.setqflist({ open = true })
end

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
    },
    config = function(_, opts)
      local options = vim.tbl_deep_extend("force", {
        options = {
          theme = 'auto',
        },
        sections = {
          lualine_a = { { 'mode', fmt = short_status } },
          lualine_b = {
            'branch',
            'diff',
            {
              'diagnostics',
              on_click = function()
                open_diagnostics_qf()
              end
            }
          },
          lualine_c = {
            {
              'filename',
              path = 3,  -- 0 = just filename, 1 = relative path, 2 = absolute path, 3 = absolute path with tilde (~) for home directory
            },
          },
          lualine_x = { 'encoding', 'fileformat' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        }
      }, opts or {})
      require("lualine").setup(options)
    end

  }
}
