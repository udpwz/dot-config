return {
  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
    opts = {
      scrollbar = {
        enable = true,
        -- The background / gutter of the scrollbar
        -- When false, only the thumb is shown.
        background = true,
      },
    },
    config = function()
      local dropbar_api = require('dropbar.api')

    end
  }
}
