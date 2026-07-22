{ inputs, ... }:
{

  flake =
    let
      myLib = import ../lib { inherit (inputs.nixpkgs) lib; };
      localOverlays = import ../overlays { inherit inputs; };

      overlays = [
        localOverlays
        # keep-sorted start
        inputs.cachyos-kernel-nix.overlays.pinned
        inputs.firefox-addons.overlays.default
        inputs.hermes-agent.overlays.default
        inputs.js0ny-packages.overlays.default
        inputs.js0ny-packages.overlays.nixpaks
        inputs.llm-agents.overlays.default
        inputs.nur.overlays.default
        inputs.vscode-extensions.overlays.default
        # keep-sorted end
        # (import ../overlays/hermes-agent.nix { inherit inputs; })
      ];

      mkSpecialArgs = system: {
        inherit inputs overlays myLib;
        nixcfgs = inputs.self;
        bindeps = inputs.bindeps;
        secrets = inputs.secrets;
        pkgsStable = inputs.nixpkgs-stable.legacyPackages.${system};
      };

      nixosHosts = [
        "bauhaus"
        "crystal"
        "polder"
        "zwinger"
        # "wsl-crystal"
      ];
      darwinHosts = [ "zen" ];

      mkNixosSystem =
        hostname:
        inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = mkSpecialArgs "x86_64-linux";
          modules = [
            # keep-sorted start
            inputs.catppuccin.nixosModules.catppuccin
            inputs.disko.nixosModules.disko
            inputs.home-manager.nixosModules.home-manager
            inputs.impermanence.nixosModules.impermanence
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.secrets.nixosModules.default
            inputs.stylix.nixosModules.default
            inputs.telegram-inline-llm-bot.nixosModules.default
            inputs.thyx.nixosModules.default
            inputs.wsl-nixos.nixosModules.default
            # keep-sorted end
            ../hosts/${hostname}
            { nixpkgs.overlays = overlays; }
          ];
        };

      mkDarwinSystem =
        hostname:
        inputs.nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = mkSpecialArgs "aarch64-darwin";
          modules = [
            ../hosts/${hostname}
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
      overlays.default = localOverlays;
      # expose allOverlays for nixd to eval
      allOverlays = overlays;

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
            hostname = "100.97.155.65";
            profiles.system = {
              user = "root";
              sshUser = "js0ny";
              interactiveSudo = false;
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos myNixosConfigs."zwinger";
            };
          };
          "crystal" = {
            hostname = "100.101.8.90";
            profiles.system = {
              user = "root";
              sshUser = "js0ny";
              interactiveSudo = true;
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos myNixosConfigs."crystal";
            };
          };
        };
      };
    };
}
