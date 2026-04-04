{
  config,
  lib,
  pkgs,
  ...
}: let
  user = config.home.username;
in
  lib.mkIf pkgs.stdenv.isDarwin {
    home.sessionPath = ["/opt/homebrew/bin"];

    programs.nh = {
      enable = true;
      flake = "/Users/${user}/.dotfiles";
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 5 --keep-since 3d";
      };
    };

    xdg.desktopEntries = lib.mkForce {};

    i18n.inputMethod.enable = false;

    programs.ghostty.systemd.enable = false;
    programs.ghostty.package = lib.mkForce pkgs.ghostty-bin;
    programs.firefox.package = lib.mkForce pkgs.firefox-bin;

    systemd.user.tmpfiles.rules = lib.mkForce [];

    home.file.".ssh/config".text = ''
      # ~/.ssh/config
      Host *
      	UseKeychain yes
      	AddKeysToAgent yes
    '';

    stylix = {
      # cursor.enable = lib.mkForce false;
      icons.enable = lib.mkForce false;
    };
  }
