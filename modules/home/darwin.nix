{
  config,
  lib,
  pkgs,
  ...
}:
let
  brew = config.nixdots.darwin.homebrew;
in
{
  imports = [
    ../common/nix-helper.nix
    ./filetype/darwin.nix
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
    };
  };
  home.sessionVariables = {
    HOMEBREW_NO_AUTO_UPDATE = 1;
    HOMEBREW_NO_ENV_HINTS = 1;
  };
}
