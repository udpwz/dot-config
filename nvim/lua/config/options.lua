-- Neovim Options Configuration

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Mouse & Clipboard
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- UI
vim.opt.showtabline = 2      -- show bufferline
vim.opt.termguicolors = true -- Better color support
vim.opt.cursorline = true    -- Highlight the current line
vim.opt.scrolloff = 8        -- Keep cursor away from screen edge
vim.opt.signcolumn = "yes"   -- Always show sign column (prevents text shifting)
vim.opt.wrap = false         -- Don't wrap lines
vim.opt.updatetime = 500     -- Faster CursorHold trigger (for hover & highlights)

-- Cursor settings
vim.opt.guicursor = "n-v-c:block-blinkwait0-blinkoff200-blinkon200,i-ci-ve:ver25-blinkwait0-blinkoff200-blinkon200,r-cr-o:hor20-blinkwait0-blinkoff200-blinkon200"

-- File handling
vim.opt.autoread = true -- Auto-reload files when changed externally

-- Netrw (file explorer)
vim.g.netrw_liststyle = 3 -- tree
vim.g.netrw_keepdir = 1   -- don't mutate CWD
vim.g.netrw_use_errorwindow = 1

-- Diagnostics
vim.diagnostic.config({
  virtual_text = false,
  -- virtual_text = {
  --   prefix = "■", -- ■ or any character you like
  --   spacing = 1, -- how many spaces between code and message
  -- },
  signs = true, -- show gutter signs
  underline = true, -- underline the problematic code
})

-- Highlight colors
vim.api.nvim_set_hl(0, "IblIndent", {
  fg = "#3B4252",
  bold = true
})

-- Cursor line highlight with increased contrast
vim.api.nvim_set_hl(0, "CursorLine", {
  bg = "#2E3440",
  bold = true
})
