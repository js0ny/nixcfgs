{ lib, config, ... }:
let
  boolToString = val: if val == true then "true" else "false";
  toRonString = val: if builtins.typeOf val == "bool" then boolToString val else toString val;
  quote = s: ''"${s}"'';
  frostedFiles = [
    "com.system76.CosmicTheme.Dark/v2/frosted_applets"
    "com.system76.CosmicTheme.Dark/v2/frosted_panel"
    "com.system76.CosmicTheme.Dark/v2/frosted_system_interface"
    "com.system76.CosmicTheme.Dark/v2/frosted_windows"
    "com.system76.CosmicTheme.Dark.Builder/v2/frosted_applets"
    "com.system76.CosmicTheme.Dark.Builder/v2/frosted_panel"
    "com.system76.CosmicTheme.Dark.Builder/v2/frosted_system_interface"
    "com.system76.CosmicTheme.Dark.Builder/v2/frosted_windows"
    "com.system76.CosmicTheme.Light/v2/frosted_applets"
    "com.system76.CosmicTheme.Light/v2/frosted_panel"
    "com.system76.CosmicTheme.Light/v2/frosted_system_interface"
    "com.system76.CosmicTheme.Light/v2/frosted_windows"
    "com.system76.CosmicTheme.Light.Builder/v2/frosted_applets"
    "com.system76.CosmicTheme.Light.Builder/v2/frosted_panel"
    "com.system76.CosmicTheme.Light.Builder/v2/frosted_system_interface"
    "com.system76.CosmicTheme.Light.Builder/v2/frosted_windows"
  ];
  toFont = family: /* ron */ ''
    (
        family: "${family}",
        weight: Normal,
        stretch: Normal,
        style: Normal,
    )
  '';
  panel = {
    anchor = "Top";
    opacity = 0.4;
    plugins_center = /* ron */ ''
      Some([
          "com.system76.CosmicAppletTime",
      ])
    '';
    plugins_wings = /* ron */ ''
      Some(([
          "com.system76.CosmicPanelLauncherButton",
          "com.system76.CosmicAppletWorkspaces",
      ], [
          "com.system76.CosmicAppletStatusArea",
          "com.system76.CosmicAppletTiling",
          "com.system76.CosmicAppletAudio",
          "com.system76.CosmicAppletBluetooth",
          "com.system76.CosmicAppletNetwork",
          "com.system76.CosmicAppletBattery",
          "com.system76.CosmicAppletNotifications",
      ]))
    '';
  };
  dock = {
    anchor = "Bottom";
    autohide = "OnOverlap";
    exclusize_zone = false;
    expand_to_edges = false;
    opacity = 1.0;
    plugins_center = /* ron */ ''
      Some([
          "com.system76.CosmicAppList",
          "com.system76.CosmicAppletMinimize",
      ])
    '';
    plugins_wing = "None";
  };
in
{
  xdg.configFile =
    lib.listToAttrs (
      map (fname: {
        name = "cosmic/${fname}";
        value.text = "true";
      }) frostedFiles
    )
    // lib.concatMapAttrs (name: value: {
      "cosmic/com.system76.CosmicPanel.Panel/v1/${name}".text = toRonString value;
    }) panel
    // lib.concatMapAttrs (name: value: {
      "cosmic/com.system76.CosmicPanel.Dock/v1/${name}".text = toRonString value;
    }) dock
    // {
      "cosmic/com.system76.CosmicSettings.Wallpaper/v1/current-folder".text =
        ''Some("${config.home.customDirs.wallpaper}")'';
      "cosmic/com.system76.CosmicTk/v1/icon_theme".text = quote config.nixdots.style.icon.dark;
      "cosmic/com.system76.CosmicTk/v1/interface_font".text =
        toFont (builtins.head config.nixdots.style.fonts.sansSerif).name;
      "cosmic/com.system76.CosmicTk/v1/monospace_font".text =
        toFont (builtins.head config.nixdots.style.fonts.editorMono).name;
    };
}
