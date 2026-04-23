local function get_hostname()
  local f = io.popen("/usr/bin/env hostname")
  local hostname = f:read("*a") or ""
  f:close()
  hostname = string.gsub(hostname, "\n$", "")
  hostname = string.gsub(hostname, ".local$", "")
  return hostname
end

-- Assuming using nix-helper, if not set, fallback to cwd
local flake = os.getenv("NH_FLAKE") or "${toString ./.}"
local base_expr = '(builtins.getFlake ("git+file://' .. flake .. '"))'
local host = get_hostname()

local nixos_expr = base_expr .. ".nixosConfigurations." .. host .. ".options"
local darwin_expr = base_expr .. ".darwinConfigurations." .. host .. ".options"

local home_expr

if vim.loop.os_uname().sysname == "Darwin" then
  home_expr = darwin_expr .. ".home-manager.users.type.getSubOptions []"
else
  home_expr = nixos_expr .. ".home-manager.users.type.getSubOptions []"
end

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
        nix_darwin = {
          expr = darwin_expr,
        },
      },
    },
  },
}
