{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkMerge [
  {
    nixdots.persist.home = {
      directories = [
        ".local/share/keyrings"
      ];
    };
    # Disable KDE Wallet
    xdg.configFile."kwalletrc".text = lib.generators.toINI { } {
      Wallet = {
        "Close When Idle" = false;
        "Close on Screensaver" = false;
        "Default Wallet" = "kdewallet";
        "Enabled" = false;
        "Idle Timeout" = 10;
        "Launch Manager" = false;
        "Leave Manager Open" = false;
        "Leave Open" = true;
        "Prompt on Open" = false;
        "Use One Wallet" = true;
      };
      "org.freedesktop.secrets".apiEnabled = true;
    };
  }
  (lib.mkIf (pkgs.stdenv.isLinux && !config.nixdots.linux.nixos) {
    services.gnome-keyring.enable = true;
  })
]
