local function getHostname()
  local f = io.popen("/usr/bin/env hostname")
  local hostname = f:read("*a") or ""
  f:close()
  hostname = string.gsub(hostname, "\n$", "")
  return hostname
end

local host = getHostname()
-- Assuming using nix-helper, if not set, fallback to cwd
local flake = os.getenv("NH_FLAKE") or "${toString ./.}"

local base_expr = '(builtins.getFlake ("git+file://' .. flake .. '"))'
local nixos_expr = base_expr .. ".nixosConfigurations." .. host .. ".options"
local home_expr = nixos_expr .. ".home-manager.users.type.getSubOptions []"

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
          expr = nixos_expr,
        },
        home_manager = {
          expr = home_expr,
        },
      },
    },
  },
}
