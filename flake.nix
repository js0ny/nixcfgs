{
  description = "Public flake for my personal NixOS and Home Manager configurations";

  inputs = {
    nixpkgs-stable.url = "github:nixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
      url = "github:petrkozorezov/firefox-addons-nix";
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
    nix-openclaw = {
      url = "github:openclaw/nix-openclaw";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
    # mac-app-util: 将通过 Nix 安装的 Darwin GUI 软件统一入口，使路径能被 Spotlight 识别且不会出现 Dock 上的重复图标
    # 在 Darwin Host 上导入后会自动启用，无需额外配置
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
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
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        {
          devShells =
            let
              ciDeps = with pkgs; [
                stylua
                prettier
                ruff
                shfmt
                shellcheck
                nixfmt
              ];
              devDeps = with pkgs; [
                lua-language-server
                pkgs.typescript-language-server
                pkgs.bash-language-server
                pyright
                taplo
                nixd
              ];
            in
            {
              default = pkgs.mkShell { buildInputs = ciDeps ++ devDeps; };
              ci = pkgs.mkShell { buildInputs = ciDeps; };
            };
          packages = import ./pkgs {
            inherit pkgs;
            lib = pkgs.lib;
          };
        };
      flake = {
        nixosModules = {
          default = import ./modules/nixos;
          server = import ./modules/nixos/server;
          desktop = import ./modules/nixos/desktop;
        };

        darwinModules = {
          default = import ./modules/darwin;
        };

        homeManagerModules = {
          base = import ./home/base.nix;
          server-base = import ./home/server-base.nix;
          darwin-base = import ./home/darwin-base.nix;
          desktop-base = import ./home/desktop-base.nix;
          desktop-extra = import ./home/desktop-extra.nix;
        };

        overlays.default = final: prev: {
          localPkgs = import ./pkgs {
            pkgs = prev;
            lib = prev.lib;
          };
        };
      };
    };
}
