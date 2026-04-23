return {
  "folke/lazydev.nvim",
  ft = "lua", -- only load on lua files
  -- lazydev automatically integrates with the `lua_ls` native LSP client.
  -- It dynamically loads Neovim types and plugins ONLY when you `require` them,
  -- which is much faster than loading the entire VIMRUNTIME in `lua_ls.lua`.
  opts = {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
  enabled = function(root_dir)
    return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
  end,
}
