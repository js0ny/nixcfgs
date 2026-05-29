{
  config,
  lib,
  pkgs,
  ...
}:
let
  darwin = config.nixdots.darwin;
  brew = darwin.homebrew;
  customDirs = config.home.customDirs;
in
{
  imports = [
    ../.
    ../../common/nix-helper.nix
    ../filetype/darwin.nix
  ];

  home.sessionPath = [ "${brew.prefix}/bin" ];

  xdg.desktopEntries = lib.mkForce { };

  i18n.inputMethod.enable = false;

  programs.ghostty.systemd.enable = false;
  programs.ghostty.package = lib.mkForce pkgs.ghostty-bin;
  programs.firefox.package = lib.mkForce pkgs.firefox-bin;

  systemd.user.tmpfiles.rules = lib.mkForce [ ];

  targets.darwin = {
    linkApps.enable = true;
    defaults = {
      "com.apple.screencapture" = {
        location = customDirs.screenshots;
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.Spotlight" = {
        # macOS 26 Spotlight
        # 不显示 iPhone Apps
        EnabledPreferenceRules = [
          "System.iphoneApps"
        ];
      };
      "io.tailscale.ipn.macsys" = lib.mkIf (config.nixdots.services.tailscale.enable) {
        HideDockIcon = 1;
        IPAddressCopiedAlertSuppressed = 1;
        UnstableUpdatesEnabled = 0;
        SUAutomaticallyUpdate = 0;
        SUHasLaunchedBefore = 1;
        TailscaleStartOnLogin = 1;
        appIntroStep = 0;
      };
    };
  };
  home.sessionVariables = {
    HOMEBREW_NO_AUTO_UPDATE = 1;
    HOMEBREW_NO_ENV_HINTS = 1;
  };

  misc.shellAliases = {
    reboot = "sudo reboot";
    clip = "pbcopy";
    paste = "pbpaste";
    ii = "open";

    brewi = "brew install";
    brewr = "brew remove";
    brewu = "brew upgrade && brew update";
    brewc = "brew cleanup";
    brewl = "brew list";
  };

}
