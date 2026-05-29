return {
  'MagicDuck/grug-far.nvim',
  ---@type grug.far.OptionsOverride
  opts = { headerMaxWidth = 80, windowCreationCommand = '40 vsplit' },
  cmd = 'GrugFar',
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
