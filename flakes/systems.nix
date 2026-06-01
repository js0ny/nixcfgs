{ inputs, ... }:
{

  flake =
    let
      myLib = import ../lib { inherit (inputs.nixpkgs) lib; };
      localOverlays = import ../overlays;

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
            ../hosts/${hostname}
            { nixpkgs.overlays = overlays; }
          ];
        };

      mkDarwinSystem =
        hostname:
        inputs.nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          inherit specialArgs;
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
}
