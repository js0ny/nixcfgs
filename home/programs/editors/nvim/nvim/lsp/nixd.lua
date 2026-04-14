local host = os.getenv("HOSTNAME") or "unknown"
local user = os.getenv("USER") or "unknown"

---@type vim.lsp.Config
return {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", ".git" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "nixfmt" },
      },
      options = {
        nixos = {
          expr = "(builtins.getFlake (toString ./.)).nixosConfigurations.crystal.options",
        },
        -- home_manager = {
        --   expr = '(builtins.getFlake ("git+file://${toString ./.}")).homeConfigurations."js0ny@crystal".options',
        -- },
      },
    },
  },
}
