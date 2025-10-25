vim.opt.number         = false
vim.opt.relativenumber = false
vim.opt.mouse          = "a"
vim.opt.clipboard      = "unnamedplus"
vim.opt.expandtab      = true
vim.opt.tabstop        = 2
vim.opt.shiftwidth     = 2
vim.opt.smartindent    = true

vim.o.showtabline      = 2     -- show bufferline
vim.opt.termguicolors  = true  -- Better color support
vim.opt.cursorline     = true  -- Highlight the current line
vim.opt.scrolloff      = 8     -- Keep cursor away from screen edge
vim.opt.signcolumn     = "yes" -- Always show sign column (prevents text shifting)

vim.g.netrw_liststyle  = 3     -- tree
vim.g.netrw_keepdir    = 1     -- don’t mutate CWD

-- When netrw is open, keep the buffer hidden instead of killing it.
-- Result: you can leave netrw, later reopen, and expansions persist.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.opt_local.bufhidden = "hide"
    vim.opt_local.buflisted = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.colorcolumn = ""
    vim.opt_local.statuscolumn = ""
  end,
  desc = "Netrw: preserve buffer",
})


vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
vim.o.wrap = false
-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 50 }
  end,
})


-- lazy.nvim bootstrap (only needed once)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none",
    "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.netrw_use_errorwindow = 1

local status_ok, lazy = pcall(require, "lazy")
if status_ok then
  lazy.setup({
    spec = {
      { import = "plugins" }
    },
    install = {
      -- colorscheme = { "onenord", "habamax" }
    },
    checker = { enabled = true },
    change_detection = {
      enabled = true,
      notify = false,
    },
  })
end

vim.api.nvim_create_user_command('InlayHint', function()
  local bufnr = 0
  local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end, { desc = "Toggle LSP inlay hints" })

vim.api.nvim_set_hl(0, "IblIndent", {
  fg = "#3B4252",
  bold = true
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype

    -- Skip formatting for git commits and if no LSP clients attached
    if ft == "gitcommit" or ft == "gitrebase" then
      return
    end

    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if #clients > 0 then
      vim.lsp.buf.format({ async = true })
    end
  end,
})
-- Escape terminal mode back to normal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("tabdo windo wincmd =")
  end,
  desc = "Auto-resize tabs and windows when the screen is resized",
})
-- Custom Command:: Filetype
vim.api.nvim_create_user_command("Dashboard", function()
  Snacks.dashboard()
end, {})

-- <leader>e: open/focus netrw at left, select the current file
vim.keymap.set("n", "<leader>e", function()
  local file = vim.fn.expand("%:p")
  -- 1) Focus existing netrw window or open one at left
  local netrw_win
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(w)
    if b > 0 and vim.bo[b].filetype == "netrw" then
      netrw_win = w; break
    end
  end
  if netrw_win then
    vim.api.nvim_set_current_win(netrw_win)
  else
    vim.cmd("Explore")
  end

  -- 2) Enforce tree style
  vim.g.netrw_liststyle = 3

  -- 3) Re-root to the file’s dir if it’s outside current netrw root
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

local modifier = vim.fn.has('mac') == 1 and '<D-p>' or '<C-p>'
vim.keymap.set('n', modifier, function()
  Snacks.picker.commands()
end, { desc = "Command Palette" })

vim.diagnostic.config({
  virtual_text = {
    prefix = "■", -- ■ or any character you like
    spacing = 1, -- how many spaces between code and message
  },
  signs = true, -- show gutter signs
  underline = true, -- underline the problematic code
})
