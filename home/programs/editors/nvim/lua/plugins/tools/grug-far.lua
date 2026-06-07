local function close_grugfar_buf()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_delete(bufnr, { force = true })
  vim.cmd('stopinsert')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('my-grug-far-custom-keybinds', { clear = true }),
  pattern = { 'grug-far' },
  callback = function()
    vim.keymap.set({ 'n', 'i' }, '<C-S-f>', close_grugfar_buf, { buffer = true })
    vim.keymap.set({ 'n' }, 'qq', close_grugfar_buf, { buffer = true })
  end,
})

return {
  'MagicDuck/grug-far.nvim',
  ---@type grug.far.OptionsOverride
  opts = { headerMaxWidth = 80, windowCreationCommand = 'rightbelow 40 vsplit' },
  cmd = { 'GrugFar', 'GrugFarWithin' },
  keys = {
    {
      '<leader>fF',
      function()
        local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
        require('grug-far').open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
          },
        })
      end,
      mode = { 'n' },
      desc = 'Search and Replace',
    },
    {
      '<C-S-f>',
      function()
        local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
        require('grug-far').open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
          },
        })
      end,
      mode = { 'n', 'v' },
      desc = 'Search and Replace',
    },
  },
}
