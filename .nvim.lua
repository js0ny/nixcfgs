require('lz.n').trigger_load('conform.nvim')

local conform = require('conform')

local formatters = conform.formatters_by_ft.nix or {}

if not vim.tbl_contains(formatters, 'keep-sorted') then
  table.insert(formatters, 1, 'keep-sorted')
end

conform.formatters_by_ft.nix = formatters

local flake = '(builtins.getFlake (builtins.toString ./.))'
local host = 'bauhaus'

vim.lsp.config['nixd'] = {
  settings = {
    nixd = {
      formatting = { command = { 'nixfmt' } },
      nixpkgs = {
        expr = string.format(
          'import %s.inputs.nixpkgs { overlays = %s.outputs.allOverlays; }',
          flake,
          flake
        ),
      },
      options = {
        ['flake-parts'] = { expr = string.format('%s.debug.options', flake) },
        ['home-manager'] = {
          expr = string.format(
            '%s.nixosConfigurations.%s.options.home-manager.users.type.getSubOptions []',
            flake,
            host
          ),
        },
        nixos = {
          expr = string.format('%s.nixosConfigurations.%s.options', flake, host),
        },
        nixvim = {
          expr = '(builtins.getFlake "github:js0ny/nvimdots/nixvim").inputs.nixvim.nixvimConfigurations.aarch64-linux.default.options',
        },
      },
    },
  },
}
