---@type vim.lsp.Config
return {
  cmd = {
    'clangd',
    '--clang-tidy',
    '--header-insertion=iwyu',
    '--completion-style=detailed',
    '--function-arg-placeholders',
    '--fallback-style=none',
  },
  filetypes = { 'c', 'cpp', 'cuda' },
  root_markers = {
    '.clangd',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    '.git',
  },
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
}
