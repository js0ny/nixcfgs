require('lz.n').trigger_load('conform.nvim')

local conform = require('conform')

local formatters = conform.formatters_by_ft.nix or {}

if not vim.tbl_contains(formatters, 'keep-sorted') then
  table.insert(formatters, 1, 'keep-sorted')
end

conform.formatters_by_ft.nix = formatters
