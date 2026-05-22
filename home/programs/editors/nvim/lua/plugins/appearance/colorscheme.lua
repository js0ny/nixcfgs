return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    opts = {
      flavor = 'auto',
      background = {
        light = 'latte',
        dark = 'mocha',
      },
      integrations = {
        'lualine',
        'blink_cmp',
      },
    },
  },
  { 'nvim-mini/mini.base16', version = false },
  {
    'f4z3r/gruvbox-material.nvim',
    name = 'gruvbox-material',
    lazy = true,
    opts = {},
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    opts = {
      variant = 'dawn',
    },
    cmd = 'FzfLua colorschemes',
  },
  { 'rebelot/kanagawa.nvim', cmd = 'FzfLua colorschemes' },
  {
    'navarasu/onedark.nvim',
    lazy = true,
    config = function()
      require('onedark').setup {
        style = 'darker',
      }
    end,
  },
}
