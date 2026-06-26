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
    { '<leader>E', '<Cmd>Neotree toggle<CR>', desc = 'Toggle Neo-tree' },
    { '<leader>ft', '<Cmd>Neotree toggle<CR>', desc = 'Toggle Neo-tree' },
    { '<C-S-e>', '<Cmd>Neotree toggle<CR>', desc = 'Toggle Neo-tree' },
  },
  ---@type neotree.Config
  config = {
    use_popups_for_input = false, -- Use `vim.ui.input()`
    close_if_last_window = false,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      filtered_items = {
        hide_dotfiles = true,
        hide_gitignored = true,
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      use_libuv_file_watcher = true,
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
