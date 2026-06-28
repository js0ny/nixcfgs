-- vim.api.nvim_create_autocmd('FileType', {
--   group = vim.api.nvim_create_augroup('custom-gitsign-keymaps', { clear = true }),
--   pattern = { 'gitsigns-blame' },
--   callback = function()
--     vim.keymap.set({ 'n' }, 'q', function()
--       vim.api.nvim_win_close(0, true)
--     end, { buffer = true })
--   end,
-- })

return { -- Git Blames, Changes
  'lewis6991/gitsigns.nvim',
  ---@type Gitsigns.Config
  opts = {
    current_line_blame = true,
    on_attach = function(bufnr)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      map('n', 'q', function()
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end)
    end,
  },
  event = 'BufReadPre',
  keys = {
    { '<leader>gb', '<cmd>Gitsigns blame<CR>', desc = 'Blame file' },
    { '<leader>gB', '<cmd>Gitsigns toggle_current_line_blame<CR>', desc = 'Toggle line blame' },
    { '[g', '<cmd>Gitsigns prev_hunk<CR>', desc = 'Prev hunk' },
    { ']g', '<cmd>Gitsigns next_hunk<CR>', desc = 'Next hunk' },
  },
}
