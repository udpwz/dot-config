return {
  {
    "okuuva/auto-save.nvim",
    version = '^1.0.0',
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        -- Don't save for special filetypes
        if vim.tbl_contains({ "gitcommit", "gitrebase", "hgcommit" }, vim.bo[buf].filetype) then
          return false
        end

        -- Use plugin's default checks for other conditions
        if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
          return true
        end
        return false
      end,
    },
  },
}
