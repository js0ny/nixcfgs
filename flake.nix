{
  description = "Public flake for my personal NixOS and Home Manager configurations";

  inputs = {
    nixpkgs-stable.url = "github:nixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    nur.url = "github:nix-community/NUR";
    # caelestia-shell - shell for wms
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # sops - Secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Niri - Wayland Window Manager
    niri-flake.url = "github:sodiboo/niri-flake";
    # xremap - kay remapper like keyd
    xremap-flake.url = "github:xremap/nix-flake";
    # betterfox - preconfigured firefox user.js
    betterfox-nix.url = "github:HeitorAugustoLN/betterfox-nix";
    firefox-addons = {
      url = "github:petrkozorezov/firefox-addons-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:kaylorben/nixcord";
    catppuccin.url = "github:catppuccin/nix";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    elephant.url = "github:abenz1267/elephant";

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };

    stylix.url = "github:nix-community/stylix";
    nix-openclaw = {
      url = "github:openclaw/nix-openclaw";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # mac-app-util: 将通过 Nix 安装的 Darwin GUI 软件统一入口，使路径能被 Spotlight 识别且不会出现 Dock 上的重复图标
    # 在 Darwin Host 上导入后会自动启用，无需额外配置
    mac-app-util.url = "github:hraban/mac-app-util";
    deploy-rs.url = "github:serokell/deploy-rs";
    llm-agents.url = "github:numtide/llm-agents.nix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nix-flatpak,
    nix-darwin,
    home-manager,
    plasma-manager,
    nur,
    caelestia-shell,
    sops-nix,
    niri-flake,
    xremap-flake,
    betterfox-nix,
    firefox-addons,
    zen-browser,
    nixcord,
    catppuccin,
    nix-index-database,
    walker,
    stylix,
    nix-openclaw,
    nixpak,
    steam-config-nix,
    mac-app-util,
    deploy-rs,
    llm-agents,
    disko,
    impermanence,
    ...
  } @ inputs: let
    myLib = import ./lib {inherit (nixpkgs) lib;};
    utils = myLib;
    localOverlays = import ./overlays;
    overlays = [
      nix-openclaw.overlays.default
      niri-flake.overlays.niri
      nur.overlays.default
      firefox-addons.overlays.default
      (final: prev: {
        caelestia-shell = caelestia-shell.packages.x86_64-linux.caelestia-shell;
      })
      (final: prev: {
        zen-browser = zen-browser.packages.x86_64-linux.zen-browser;
      })
      localOverlays
    ];
    forSystem = system:
      import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
    specialArgs = {inherit inputs overlays myLib;};
    nixosHosts = [
      # "zp"
      "crystal"
      "polder"
    ];
    darwinHosts = [
      "zen"
    ];

    mkNixosSystem = hostname:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit specialArgs;
        modules = [
          home-manager.nixosModules.home-manager
          xremap-flake.nixosModules.default
          sops-nix.nixosModules.sops
          catppuccin.nixosModules.catppuccin
          stylix.nixosModules.default
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          ./hosts/${hostname}
          {nixpkgs.overlays = overlays;}
        ];
      };
    mkDarwinSystem = hostname:
      nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        inherit specialArgs;
        modules = [
          ./hosts/${hostname}
          {nixpkgs.overlays = overlays;}
          mac-app-util.darwinModules.default
        ];
      };
  in {
    homeConfigurations = {
      "js0ny@crystal" = home-manager.lib.homeManagerConfiguration {
        pkgs = forSystem "x86_64-linux";
        extraSpecialArgs = specialArgs // {inherit utils;};
        modules = [
          ./users/js0ny/crystal.nix
          nix-openclaw.homeManagerModules.openclaw
          plasma-manager.homeModules.plasma-manager
          nix-flatpak.homeManagerModules.nix-flatpak
          sops-nix.homeManagerModules.sops
          niri-flake.homeModules.niri
          betterfox-nix.modules.homeManager.betterfox
          nixcord.homeModules.nixcord
          catppuccin.homeModules.catppuccin
          nix-index-database.homeModules.nix-index
          walker.homeManagerModules.default
          stylix.homeModules.stylix
          steam-config-nix.homeModules.default
        ];
      };
      "js0ny@zen" = home-manager.lib.homeManagerConfiguration {
        pkgs = forSystem "aarch64-darwin";
        extraSpecialArgs = specialArgs;
        modules = [
          mac-app-util.homeManagerModules.default
          nix-openclaw.homeManagerModules.openclaw
          ./users/js0ny/zen.nix
          catppuccin.homeModules.catppuccin
          betterfox-nix.modules.homeManager.betterfox
          sops-nix.homeManagerModules.sops
          stylix.homeModules.stylix
          nix-index-database.homeModules.nix-index
        ];
      };
    };
    # Export nixos modules for private use
    nixosModules = {
      default = import ./modules/nixos;
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
    devShells =
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ] (system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        ciDeps = with pkgs; [
          stylua
          prettier
          ruff
          shfmt
          shellcheck
          alejandra
        ];
        devDeps = with pkgs; [
          lua-language-server
          typescript-language-server
          bash-language-server
          pyright
          taplo
          nixd
        ];
      in {
        default = pkgs.mkShell {
          buildInputs = ciDeps ++ devDeps;
          shellHook = ''

          '';
        };
        ci = pkgs.mkShell {
          buildInputs = ciDeps;
          shellHook = ''

          '';
        };
      });
  };
}
