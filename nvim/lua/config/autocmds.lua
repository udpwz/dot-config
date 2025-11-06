-- Autocmds and User Commands Configuration

-- LSP Attach: Setup keymaps and document highlighting
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func,
        { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- defaults:
    -- https://neovim.io/doc/user/news-0.11.html#_defaults

    map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("<leader>rrn", vim.lsp.buf.rename, "Rename all references")

    local function client_supports_method(client, method, bufnr)
      if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight',
        { clear = false })

      -- When cursor stops moving: Highlights all instances of the symbol under the cursor
      -- When cursor moves: Clears the highlighting
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      -- When LSP detaches: Clears the highlighting
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

  end,

})

-- Netrw: Preserve buffer and customize appearance
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

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 50 }
  end,
})

-- Auto-resize windows when vim is resized
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("tabdo windo wincmd =")
  end,
  desc = "Auto-resize tabs and windows when the screen is resized",
})

-- Format on insert leave (disabled - use manual keymaps instead)
-- vim.api.nvim_create_autocmd("InsertLeave", {
--   pattern = "*",
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     local ft = vim.bo[bufnr].filetype
--
--     -- Skip formatting for git commits and if no LSP clients attached
--     if ft == "gitcommit" or ft == "gitrebase" then
--       return
--     end
--
--     local clients = vim.lsp.get_clients({ bufnr = bufnr })
--     if #clients > 0 then
--       vim.lsp.buf.format({ async = true })
--     end
--   end,
-- })

-- Auto-reload files when changed externally
vim.opt.autoread = true

vim.api.nvim_create_autocmd(
  { 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = vim.api.nvim_create_augroup('auto-reload', { clear = true }),
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd('checktime')
    end
  end,
})

-- Notification when file is reloaded
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = vim.api.nvim_create_augroup('file-changed-notification',
    { clear = true }),
  callback = function()
    vim.notify('File changed on disk. Buffer reloaded.', vim.log.levels.WARN)
  end,
})

-- Quickfix: Toggle with mouse click
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<LeftMouse>", function()
      local mouse_pos = vim.fn.getmousepos()
      local line = mouse_pos.line
      local current_line = vim.fn.line(".")

      -- If clicking on the same line, toggle quickfix
      if line == current_line then
        vim.cmd("cclose")
      else
        -- Otherwise, position cursor and open the entry
        vim.fn.setpos(".", {0, line, mouse_pos.column, 0})
        vim.cmd("normal! \r")
      end
    end, { buffer = true, desc = "Toggle quickfix or jump to entry" })
  end,
  desc = "Quickfix: mouse click to toggle or jump",
})

-- User Commands

-- Toggle LSP inlay hints
vim.api.nvim_create_user_command('InlayHint', function()
  local bufnr = 0
  local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end, { desc = "Toggle LSP inlay hints" })

-- Buffer picker (override ls command)
vim.api.nvim_create_user_command('LS', function()
  require('snacks').picker.buffers()
end, { desc = 'Open buffer picker' })

vim.cmd('cnoreabbrev ls LS')

-- Dashboard
vim.api.nvim_create_user_command("Dashboard", function()
  Snacks.dashboard()
end, {})
