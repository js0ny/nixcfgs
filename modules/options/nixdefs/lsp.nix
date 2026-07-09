{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdefs.lsp;
  sysFlake = ''(builtins.getFlake ("github:js0ny/nixcfgs"))'';
  # username = config.nixdots.user.name;
  # independentHomeExpr = ''(builtins.getFlake ("git+file://${flake}")).homeConfigurations.${username}.options'';
  lspServerType = lib.types.submodule {
    options = {
      client = {
        cmd = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "pyright-langserver"
            "--stdio"
          ];
          description = "Commands that run the lsp.";
        };

        filetypes = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "python" ];
        };

        rootMarkers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "pyproject.toml"
            ".git"
            "uv.lock"
          ];
        };
      };

      serverSettings = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Language server specific settings payload.";
      };
    };
  };
in
{
  options.nixdefs = {
    lsp = {
      enable = lib.mkEnableOption "Global LSP tools and configurations";

      servers = lib.mkOption {
        type = lib.types.attrsOf lspServerType;
        default = { };
        description = "Declarative configuration for various LSP servers.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nixdefs.lsp.servers = {
      nixd = {
        client = {
          cmd = lib.mkDefault [ "${lib.getExe pkgs.nixd}" ];
          filetypes = lib.mkDefault [ "nix" ];
          rootMarkers = lib.mkDefault [
            "flake.nix"
            ".git"
          ];
        };
        serverSettings = {
          # The expressions are simply nix expression, explore them via `nix repl`
          nixpkgs.expr = /* nix */ "import ${sysFlake}.inputs.nixpkgs { overlays = ${sysFlake}.outputs.allOverlays; }";
          formatting.command = [ (lib.getExe pkgs.nixfmt) ];
          options = rec {
            nixos.expr = /* nix */ "${sysFlake}.nixosConfigurations.bauhaus.options";
            home-manager.expr = /* nix */ "${nixos.expr}.home-manager.users.type.getSubOptions []";
            flake-parts.expr = /* nix */ "${sysFlake}.debug.options";
          };
        };
      };
      lua-language-server = {
        serverSettings = {
          telemetry.enable = false;
        };
      };
    };
  };
}
