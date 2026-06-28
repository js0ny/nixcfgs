{
  flake.nixosModules.chromium = _: {
    programs.chromium = {
      enable = true;
      # https://chromeenterprise.google/intl/en_uk/policies/
      extraOpts = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        AutoplayAllowed = false;
        PasswordManagerEnabled = false;
        DefaultBrowserSettingEnabled = false;
        ImportAutofillFormData = false;
        ImportBookmarks = false;
        ImportHistory = false;
        ImportHomepage = false;
        ImportSavedPasswords = false;
        ImportSearchEngine = false;
        MetricsReportingEnabled = false;
        SpellCheckServiceEnabled = false;
        SpellcheckEnabled = false;
        TranslateEnabled = true;
        ShowHomeButton = true;
      };
      extensions = [
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # UBlock Origin Lite
        "edibdbjcniadpccecjdfdjjppcpchdlm" # I still don't care about cookies
      ];
    };
  };

  flake.homeModules.chromium =
    {
      config,
      ...
    }:
    {
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
          "--enable-parallel-downloading"
          "--disk-cache-dir=${config.xdg.cacheHome}/chromium-cache"
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
    };

}
