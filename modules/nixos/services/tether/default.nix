{
  flake.nixosModules.tether =
    {
      config,
      inputs,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.tether;
    in
    {
      imports = [ inputs.tether.nixosModules.default ];

      # https://github.com/zackb/tether#use-the-nixos-module
      programs.tether = {
        enable = true;
        wifi = {
          enable = true;
          openFirewall = true;
        };
        bluetooth = {
          enable = true;
          adapters = [ "hci0" ];
        };
        # [Human Intervention] Install the extensions from the store, they are not
        # packaged in Nix. The Chromium one ships no store listing, side-load it.
        # https://addons.mozilla.org/en-US/firefox/addon/tether-browser-extension/
        # https://addons.thunderbird.net/en-US/thunderbird/addon/tether-mail-extension/
        extensions = [
          "firefox"
          "chromium"
          "thunderbird"
        ];
      };

      # The upstream module swaps `programs.thunderbird.package` for a `mkDefault`,
      # which loses against the sandboxed nixpaks build configured here, so redo the
      # swap on top of it. Thunderbird's wrapper also defaults to linking native
      # messaging hosts into `~/.mozilla` at runtime, which the sandbox cannot write
      # to, so point it at the system directory in its own prefix instead.
      programs.thunderbird.package = lib.mkIf (builtins.elem "thunderbird" cfg.extensions) (
        lib.mkForce (
          pkgs.nixpaks.thunderbird.override {
            package = pkgs.thunderbird.override {
              nativeMessagingHosts = [ cfg.package ];
              hasMozSystemDirPatch = true;
            };
          }
        )
      );

      home-manager.sharedModules = [
        {
          # Pairing keys, contacts and journal live in the user's home, which is
          # ephemeral on hosts using preservation.
          js0ny.persist.stores.state.directories = [
            ".config/tether"
            ".local/share/tether"
            ".local/state/tether"
          ];
        }
      ];
    };
}
