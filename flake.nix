{
  description = "Public flake for my personal NixOS and Home Manager configurations";

  inputs = {
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-stable.url = "github:nixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    # flake-utils.url = "github:numtide/flake-utils";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    # sops - Secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Niri - Wayland Window Manager
    niri-flake.url = "github:sodiboo/niri-flake";
    # xremap - kay remapper like keyd
    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    # betterfox - preconfigured firefox user.js
    betterfox-nix = {
      url = "github:HeitorAugustoLN/betterfox-nix";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      # url = "github:petrkozorezov/firefox-addons-nix";
      url = "github:xddxdd/firefox-addons-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    elephant.url = "github:abenz1267/elephant";

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nur.follows = "nur";
    };
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "git+ssh://forgejo@git.js0ny.net/js0ny/nix-secrets.git";
    };
    bindeps = {
      url = "git+ssh://forgejo@git.js0ny.net/js0ny/bindeps.git?lfs=1";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks.flakeModule
      ];

      perSystem =
        { config, pkgs, ... }:
        {
          treefmt.config = {
            projectRootFile = "flake.nix";
            settings.excludes = [
              "_sources/generated.json"
            ];
            programs.keep-sorted = {
              enable = true;
              excludes = [
                "*.json"
                "*.md"
              ];
            };
            programs.prettier = {
              enable = true;
              excludes = [
                "_sources/*.json"
              ];
            };
            # keep-sorted start
            programs.nixfmt.enable = true;
            programs.shfmt.enable = true;
            programs.stylua.enable = true;
            # keep-sorted end
          };

          pre-commit = {
            check.enable = true;
            settings.hooks.treefmt.enable = true;
          };

          devShells =
            let
              ciDeps = with pkgs; [
                stylua
                prettier
                ruff
                shfmt
                shellcheck
                nixfmt
                nvfetcher
                nufmt
              ];
              devDeps = with pkgs; [
                lua-language-server
                pkgs.typescript-language-server
                pkgs.bash-language-server
                pyright
                taplo
                nixd
                nushell
              ];
            in
            {
              default = pkgs.mkShell {
                inputsFrom = [ config.pre-commit.devShell ];
                buildInputs = ciDeps ++ devDeps;
              };
              ci = pkgs.mkShell { buildInputs = ciDeps; };
            };
          packages =
            let
              flattenPackages =
                prefix: attrs:
                pkgs.lib.concatMapAttrs (
                  name: value:
                  let
                    packageName = if prefix == "" then name else "${prefix}-${name}";
                  in
                  if pkgs.lib.isDerivation value then
                    { ${packageName} = value; }
                  else if pkgs.lib.isAttrs value then
                    flattenPackages packageName value
                  else
                    { }
                ) attrs;
            in
            flattenPackages "" (
              import ./pkgs {
                inherit pkgs;
                lib = pkgs.lib;
              }
            );
        };
      flake = {
        nixosModules = {
          default = import ./nixos;
          server = import ./nixos/server;
          desktop = import ./nixos/desktop;
        };

        darwinModules = {
          default = import ./darwin;
        };

        homeManagerModules = {
          server-base = import ./home/server-base.nix;
          darwin-base = import ./home/darwin-base.nix;
          desktop-base = import ./home/desktop-base.nix;
          desktop-extra = import ./home/desktop-extra.nix;
          wsl = import ./home/wsl.nix;
        };

        overlays.default = import ./overlays { inherit inputs; };
      };
    };
}
