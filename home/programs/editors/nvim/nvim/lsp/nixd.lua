local host = os.getenv("HOSTNAME") or "unknown"
local user = os.getenv("USER") or "unknown"

---@type vim.lsp.Config
return {
  cmd = { "nixd" },
  root_markers = { "flake.nix", "flake.lock" },
  filetypes = { "nix" },
  settings = {
    nixpkgs = {
      expr = "import <nixpkgs> { }",
    },
    formatting = {
      command = { "alejandra" },
    },
    options = {
      nixos = {
        expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.' .. host .. ".options",
      },
      home_manager = {
        expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."'
          .. user
          .. "@"
          .. host
          .. '".options',
      },
    },
  },
}
