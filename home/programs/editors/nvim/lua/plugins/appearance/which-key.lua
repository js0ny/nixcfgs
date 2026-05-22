---@type LazyPluginSpec
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = { preset = Config.is_tty and 'classic' or 'modern' },
  keys = {
    {
      '<leader>H',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}
