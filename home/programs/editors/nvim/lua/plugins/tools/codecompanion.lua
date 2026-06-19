return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    {
      '<C-CR>',
      function()
        require('codecompanion').toggle()
      end,
      desc = 'Code Companion Chat',
    },
  },
  opts = {
    opts = {
      log_level = 'DEBUG', -- or "TRACE"
    },
    interactions = {
      chat = {
        adapter = 'opencode',
      },
    },
    display = {
      chat = {
        window = {
          layout = 'vertical',
          position = 'right',
          width = 0.35,
        },
      },
    },
    adapters = {
      acp = {
        opencode = function()
          return require('codecompanion.adapters').extend('opencode', {
            commands = {
              default = {
                'opencode',
                'acp',
              },
            },
          })
        end,
      },
    },
  },
}
