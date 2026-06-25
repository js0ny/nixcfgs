-- plugins/treesitter.lua
local parsers = {
  -- keep-sorted start
  'bash',
  'udev',
  'c',
  'c_sharp',
  'cpp',
  'css',
  'fish',
  'go',
  'hcl',
  'html',
  'ini',
  'javascript',
  'json',
  'kdl',
  'latex',
  'lua',
  'markdown',
  'markdown_inline',
  'nginx',
  'nix',
  'nu',
  'python',
  'query',
  'ruby',
  'rust',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
  -- keep-sorted end
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup()

    -- async, already installed = no-op
    require('nvim-treesitter').install(parsers)

    vim.api.nvim_create_autocmd('FileType', {
      pattern = parsers,
      callback = function()
        vim.treesitter.start()

        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
