-- Lua
--[[ Installation
scoop install lua-language-server
brew install lua-language-server
sudo port install lua-language-server
--]]
--[[ Build: Ninja & C++17 Required
git clone https://github.com/LuaLS/lua-language-server --depth 1
cd lua-language-server
./make.sh
--]]
--[[ Note: For building from source, wrapper script is required
Accompanied with a wrapper script
#!/bin/bash
exec "$HOME/.local/build/lua-language-server/bin/lua-language-server" "$@"
--]]
-- Note: The filename MUST be strictly `lua_ls.lua` to match the standard LSP client name.
-- We do not manually configure `workspace.library` or Neovim API types here.
-- `lazydev.nvim` automatically injects the Neovim runtime and plugins into `lua_ls`
-- based on this exact client name, making manual configuration redundant and potentially conflicting.
---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  on_init = function(client)
    local path = client.workspace_folders and client.workspace_folders[1] and client.workspace_folders[1].name
    if path and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
      return
    end
    client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        workspace = {
          maxPreload = 10000,
          preloadFileSize = 1000,
        },
      },
    })
    client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end,
  settings = {
    Lua = {
      -- Inlay hints
      hint = {
        enable = true,
        setType = true,
        arrayIndex = "Disable",
      },
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = "Replace",
        postfix = ".",
        displayContext = 50,
      },
      telemetry = {
        enable = false,
      },
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}
