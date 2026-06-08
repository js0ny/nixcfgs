vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('my-grug-far-custom-keybinds', { clear = true }),
  pattern = { 'grug-far' },
  callback = function(args)
    local bufnr = args.buf

    local function close()
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end

    vim.keymap.set({ 'n', 'i' }, '<C-S-f>', close, {
      buffer = bufnr,
    })
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
