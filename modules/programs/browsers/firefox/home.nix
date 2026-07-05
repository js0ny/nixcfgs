{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  profileDir = config.nixdefs.consts.firefox.profileDir;
  persistDir = lib.removeSuffix "/firefox" profileDir;
  cfg = config.nixdots.programs.firefox;
  profile = config.nixdots.programs.firefox.defaultProfile;
  policies = import ./policies.nix;
  isNixOS = config.nixdots.linux.enable && config.nixdots.linux.nixos;
  scanPaths = (import ../../../../lib { inherit lib; }).scanPaths;
in
{
  imports = [
    ./search.nix
    ./containers.nix
    ./userjs.nix
    ./addons.nix
    ./global-speed.nix
    ./cookie-autodelete.nix
    ./sidebery.nix

    inputs.betterfox-nix.modules.homeManager.betterfox
  ]
  ++ scanPaths ./hm-options;
  # Upstream: https://github.com/nix-community/stylix/issues/2071
  stylix.targets.firefox = {
    profileNames = [ "${profile}" ];
    enable = false;
  };

  programs.firefox.configPath = "${config.home.homeDirectory}/${profileDir}";

  programs.firefox = {
    enable = cfg.enable;
    # package =
    #   if isNixOS then
    #     pkgs.nixpaks.firefox
    #   else if pkgs.stdenv.isDarwin then
    #     pkgs.firefox-bin
    #   else
    #     pkgs.firefox;
  };

  # antidots
  home.file.".mozilla/native-messaging-hosts/.keep".enable = lib.mkForce false;

  nixdots.persist.home = lib.mkIf (cfg.enable) { directories = [ persistDir ]; };
  programs.firefox.policies = lib.mkIf pkgs.stdenv.isDarwin policies;

  # Betterfox
  programs.firefox.betterfox = {
    enable = true;
    profiles."${profile}".settings = {
      securefox.enable = true;
      peskyfox.enable = true;
    };
  };

  # Keymaps
  home.file."${profileDir}/${profile}/customKeys.json" = {
    text = builtins.toJSON {
      key_privatebrowsing = {
        modifiers = "accel,shift";
        key = "N";
      };
      key_undoCloseWindow = { };
      viewGenaiChatSidebarKb = { };
      key_viewInfo = { };
      key_switchTextDirection = { };
    };
    force = true;
  };
  programs.firefox.profiles."${profile}" = {
    userChrome = builtins.readFile ./userChrome.css;
    userContent = ''
      @import "${pkgs.misc.data.firefox-csshacks}/content/multi_column_addons.css"
      @import "${pkgs.misc.data.firefox-csshacks}/content/compact_about_config.css"
    '';
  };
}
