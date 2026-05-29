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
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };
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
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    telegram-inline-llm-bot.url = "github:js0ny/telegram-inline-llm-bot";
    srvos = {
      url = "github:nix-community/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    bifrost = {
      url = "github:maximhq/bifrost";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      imports = [
        ./flakes/devshells.nix
        ./flakes/treefmt.nix
        ./flakes/packages.nix
      ];

      flake =
        let
          myLib = import ./lib { inherit (inputs.nixpkgs) lib; };
          localOverlays = import ./overlays { inherit inputs; };

          overlays = [
            inputs.niri-flake.overlays.niri
            inputs.nur.overlays.default
            inputs.firefox-addons.overlays.default
            inputs.nix-cachyos-kernel.overlays.pinned
            localOverlays
          ];

          specialArgs = {
            inherit inputs overlays myLib;
            nixcfgs = inputs.self;
            bindeps = inputs.bindeps;
            secrets = inputs.secrets;
          };

          nixosHosts = [
            "crystal"
            "polder"
            "zwinger"
            "wsl-crystal"
          ];
          darwinHosts = [ "zen" ];

          mkNixosSystem =
            hostname:
            inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              inherit specialArgs;
              modules = [
                # keep-sorted start
                inputs.catppuccin.nixosModules.catppuccin
                inputs.disko.nixosModules.disko
                inputs.home-manager.nixosModules.home-manager
                inputs.impermanence.nixosModules.impermanence
                inputs.lanzaboote.nixosModules.lanzaboote
                inputs.nixos-wsl.nixosModules.default
                inputs.secrets.nixosModules.default
                inputs.sops-nix.nixosModules.sops
                inputs.stylix.nixosModules.default
                inputs.telegram-inline-llm-bot.nixosModules.default
                # keep-sorted end
                ./hosts/${hostname}
                { nixpkgs.overlays = overlays; }
              ];
            };

          mkDarwinSystem =
            hostname:
            inputs.nix-darwin.lib.darwinSystem {
              system = "aarch64-darwin";
              inherit specialArgs;
              modules = [
                ./hosts/${hostname}
                { nixpkgs.overlays = overlays; }
                inputs.mac-app-util.darwinModules.default
                inputs.home-manager.darwinModules.default
                inputs.stylix.darwinModules.stylix
                inputs.secrets.darwinModules.default
              ];
            };

          myNixosConfigs = inputs.nixpkgs.lib.genAttrs nixosHosts mkNixosSystem;
          myDarwinConfigs = inputs.nixpkgs.lib.genAttrs darwinHosts mkDarwinSystem;
        in
        {
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

          overlays.default = localOverlays;

          nixosConfigurations = myNixosConfigs;
          darwinConfigurations = myDarwinConfigs;

          deploy = {
            sshOpts = [
              "-p"
              "2223"
            ];
            nodes = {
              "polder" = {
                hostname = "100.92.207.11";
                profiles.system = {
                  user = "root";
                  sshUser = "js0ny";
                  interactiveSudo = false;
                  path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos myNixosConfigs."polder";
                };
              };
              "zwinger" = {
                hostname = "100.71.26.71";
                profiles.system = {
                  user = "root";
                  sshUser = "js0ny";
                  interactiveSudo = false;
                  path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos myNixosConfigs."zwinger";
                };
              };
            };
          };
        };
    };
}
