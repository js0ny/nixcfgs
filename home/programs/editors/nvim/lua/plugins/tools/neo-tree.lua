return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>E', ':Neotree toggle<CR>', desc = 'Toggle Neo-tree' },
    { '<leader>ft', ':Neotree toggle<CR>', desc = 'Toggle Neo-tree' },
    { '<C-S-e>', ':Neotree toggle<CR>', desc = 'Toggle Neo-tree' },
  },
  ---@type neotree.Config
  config = {
    use_popups_for_input = false, -- Use `vim.ui.input()`
    close_if_last_window = true,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      filtered_items = {
        hide_dotfiles = true,
        hide_gitignored = true,
      },
    },
    window = {
      mappings = {
        ['l'] = 'open',
        ['h'] = 'close_node',
      },
    },
    source_selector = {
      winbar = true,
      statusline = false,
      truncation_character = '…',
    },
  },
}
