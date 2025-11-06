-- Keymaps Configuration

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>",
  { desc = "Clear search highlight" })

-- Escape terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- File explorer - reveal current file in netrw
vim.keymap.set("n", "<leader>e", function()
  local file = vim.fn.expand("%:p")
  -- 1) Focus existing netrw window or open one at left
  local netrw_win
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(w)
    if b > 0 and vim.bo[b].filetype == "netrw" then
      netrw_win = w
      break
    end
  end
  if netrw_win then
    vim.api.nvim_set_current_win(netrw_win)
  else
    vim.cmd("Explore")
  end

  -- 2) Enforce tree style
  vim.g.netrw_liststyle = 3

  -- 3) Re-root to the file's dir if it's outside current netrw root
  if file ~= "" then
    local root = vim.b.netrw_curdir or vim.fn.getcwd()
    if file:sub(1, #root) ~= root then
      vim.cmd("Explore " .. vim.fn.fnameescape(vim.fn.fnamemodify(file, ":p:h")))
    end
    -- 4) Select the filename in the tree
    local name = vim.fn.fnamemodify(file, ":t")
    vim.fn.search("\\V" .. vim.fn.escape(name, [[\]]), "cw")
  end
end, { desc = "Reveal current file in netrw" })

-- Command Palette (Cmd+P on Mac, Ctrl+P on other platforms)
local modifier = '<C-p>'
vim.keymap.set('n', modifier, function()
  Snacks.picker.commands()
end, { desc = "Command Palette" })

-- Format entire buffer with Ctrl+Shift+I
vim.keymap.set('n', '<C-S-i>', function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

-- Format visual selection with Ctrl+Shift+I
vim.keymap.set('v', '<C-S-i>', function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format selection" })
