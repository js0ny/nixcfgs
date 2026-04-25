--[[
Environment Variable Configurations:
* NH_FLAKE:              Absolute path to the Flake root directory. If `programs.nh` is enabled, this is typically set automatically.
* NIXD_NIXOS_HOST:       Overrides the default NixOS target hostname (defaults to the current system's hostname).
* NIXD_DARWIN_HOST:      Overrides the default nix-darwin target hostname (defaults to the current system's hostname).
* NIXD_INDEPENDENT_HOME: Flag (e.g. set to 1). When enabled, it evaluates home-manager options using the standalone mode rather than the host system's integrated module mode.
* NIXD_HOME_TARGET:      Specifies the target configuration name in standalone mode (e.g. "user" or "user@hostname"). Only takes effect if NIXD_INDEPENDENT_HOME is enabled. Defaults to "$USER@<hostname>".
--]]
local function get_hostname()
  local hostname = vim.fn.hostname()
  hostname = string.gsub(hostname, "\n$", "")
  hostname = string.gsub(hostname, ".local$", "")
  return hostname
end

local flake = os.getenv("NH_FLAKE") or vim.fn.getcwd()
local base_expr = '(builtins.getFlake ("git+file://' .. flake .. '"))'

local is_darwin = vim.loop.os_uname().sysname == "Darwin"
local nixos_host = os.getenv("NIXD_NIXOS_HOST") or get_hostname()
local darwin_host = os.getenv("NIXD_DARWIN_HOST") or get_hostname()

local nixos_options_expr = base_expr .. ".nixosConfigurations." .. nixos_host .. ".options"
local darwin_options_expr = base_expr .. ".darwinConfigurations." .. darwin_host .. ".options"
local nixos_home_expr = nixos_options_expr .. ".home-manager.users.type.getSubOptions []"
local darwin_home_expr = darwin_options_expr .. ".home-manager.users.type.getSubOptions []"

local options = {}

if not is_darwin then
  options.nixos = { expr = nixos_options_expr }
  if os.getenv("NIXD_DARWIN_HOST") then
    options.darwin = { expr = darwin_options_expr }
  end
else
  options.darwin = { expr = darwin_options_expr }
  if os.getenv("NIXD_NIXOS_HOST") then
    options.nixos = { expr = nixos_options_expr }
  end
end

if os.getenv("NIXD_INDEPENDENT_HOME") then
  local user = os.getenv("USER") or "default"
  local home_target = os.getenv("NIXD_HOME_TARGET") or (user .. "@" .. get_hostname())

  local standalone_home_expr = base_expr .. '.homeConfigurations."' .. home_target .. '".options'
  options["home-manager"] = { expr = standalone_home_expr }
else
  if not is_darwin then
    options["home-manager"] = { expr = nixos_home_expr }
  else
    options["home-manager"] = { expr = darwin_home_expr }
  end
end

if os.getenv("NIXD_NVIM_DEBUG") then
  print(nixos_home_expr)
  print(nixos_options_expr)
  print(darwin_home_expr)
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
      options = options,
    },
  },
}
