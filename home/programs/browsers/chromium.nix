{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.programs.chromium;
in
lib.mkIf cfg.enable {
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      # Done by NIXOS_OZONE_WL=1
      # "--enable-wayland-ime"
      # "--enable-features=WaylandWindowDecorations"
      # "--enable-features=UseOzonePlatform"
      # "--ozone-platform-hint=auto"
      # See: https://wiki.archlinux.org/title/Chromium#Touchpad_gestures_for_navigation
      "--enable-features=TouchpadOverscrollHistoryNavigation"
      "--enable-features=MiddleClickAutoscroll"
    ];
    extensions = map (x: { id = x; }) [
      "bggfcpfjbdkhfhfmkjpbhnkhnpjjeomc" # Material Icons for GitHub
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
      "ghmbeldphafepmbegfdlkpapadhbakde" # proton pass
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
      "gfbliohnnapiefjpjlpjnehglfpaknnc" # surfingkeys
      "dhdgffkkebhmkfjojejmpbldmpobfkfo" # tampermonkey
      "jlgkpaicikihijadgifklkbpdajbkhjo" # CrxMouse: Mouse Gestures
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock for Youtube
      "clngdbkpkpeebahjckkjfobafhncgmne" # Stylus
      "jpbjcnkcffbooppibceonlgknpkniiff" # Global Speed
      "bdiifdefkgmcblbcghdlonllpjhhjgof" # Kiss Translator
      "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube Dislike
      "edibdbjcniadpccecjdfdjjppcpchdlm" # I still don't care about cookies
      "kdbmhfkmnlmbkgbabkdealhhbfhlmmon" # SteamDB
      "ngonfifpkpeefnhelnfdkficaiihklid" # ProtonDB for Steam
      "eaoelafamejbnggahofapllmfhlhajdd" # 小电视空降助手 Bili sponsorblock
      "kkmfljfnlmppiaoijkfaejgkhccokpdn" # WHEELY: Wheel scroll for Linux
    ];
  };
  nixdots.persist.home = {
    directories = [
      ".config/chromium"
    ];
  };
  mergetools.chromiumPrefs = {
    target = "${config.xdg.configHome}/chromium/Default/Preferences";
    format = "json";
    force = true;

    settings = {
      extensions.ui.developer_mode = true;
    };
  };
}
