---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  on_init = function(client)
    local path = client.workspace_folders
      and client.workspace_folders[1]
      and client.workspace_folders[1].name
    if
      path and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
    then
      return
    end
    client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        workspace = {
          maxPreload = 10000,
          preloadFileSize = 1000,
        },
      },
    })
    client:notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  end,
  settings = {
    Lua = {
      hint = {
        enable = true,
        setType = true,
        arrayIndex = 'Disable',
      },
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = 'Replace',
        postfix = '.',
        displayContext = 50,
      },
      telemetry = {
        enable = false,
      },
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
}
