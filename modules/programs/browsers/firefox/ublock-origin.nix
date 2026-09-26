{
  # https://wiki.nixos.org/wiki/Firefox
  # UBO migrates to new settings schema after 1.33.0, the config in nixos wiki is still supported
  # https://github.com/gorhill/uBlock/wiki/Deploying-uBlock-Origin:-configuration
  # https://github.com/gorhill/uBlock/blob/1c3b45f75d0f84d68abb51b15bbdc043464ee3e0/src/js/background.js#L86-L109
  userSettings = [
      /*nixfmt:disable*/
      [ "advancedUserEnabled" "true"]
      [ "uiAccentCustom" "true" ]
      [ "uiTheme" "auto" ]
      /*nixfmt:enable*/
  ];
  toOverwrite = {
    # Filter lists > click `View` button > URL param url=
    # For example, Region, languages > cn tw: AdGuard Chiense (中文)
    # moz-extension://1c2a9972-d26b-4c88-80ec-444cc732b323/asset-viewer.html?url=CHN-0
    # refers to CHN-0 in policy storage
    filterLists = [
      "urlhaus-1"
      "CHN-0"
      "ublock-filters"
      "ublock-badware"
      "ublock-privacy"
      "ublock-quick-fixes"
      "ublock-unbreak"
      "easylist"
      "easyprivacy"
      "plowe-0"
      "user-filters"
    ];
  };
}
