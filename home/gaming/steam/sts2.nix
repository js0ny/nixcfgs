{ pkgs, config, ... }:
let
  id = 2868840;
  steamId = config.secrets.plain.steamId;
  saveDir =
    if pkgs.stdenv.isDarwin then
      "${config.home.homeDirectory}/Library/Application Support/SlayTheSpire2/steam/${toString steamId}"
    else
      "${config.xdg.dataHome}/SlayTheSpire2/steam/${toString steamId}";
  mods = pkgs.misc.mods.slay-the-spire-2;
  modDir = ".local/share/Steam/steamapps/common/Slay the Spire 2/mods";
in
{
  # Fix: Slay the Spire 2 "SpeedX" mod initialization crash
  # MonoMod extracts 'mm-exhelper.so' at runtime to /tmp, bypassing NixOS RPATH patching.
  # It fails to resolve '_Unwind_RaiseException' due to missing libgcc_s.so.1.
  programs.steam.config.apps.sts2 = {
    id = id;
    launchOptions = {
      env = {
        LD_PRELOAD = "${pkgs.stdenv.cc.cc.lib}/lib/libgcc_s.so.1";
      };
      args = [
        "--display-driver wayland"
      ];
    };
  };
  nixdots.persist.home = {
    directories = [
      ".local/share/SlayTheSpire2"
    ];
  };
  mergetools.SlayTheSpire2Settings = {
    target = "${saveDir}/settings.save";
    format = "json";
    settings = {
      "skip_intro_logo" = true;
    };
  };
  home.file = {
    "${modDir}/ModConfig".source = mods.modconfig;
    "${modDir}/SpeedX".source = mods.speedx;
    "${modDir}/DamageMeter".source = mods.damagemeter;
    "${modDir}/QuickRestart".source = mods.quick-restart;
  };
}
