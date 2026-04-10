{ pkgs, ... }:
let
  id = 2868840;
in
{
  # Fix: Slay the Spire 2 "SpeedX" mod initialization crash
  # MonoMod extracts 'mm-exhelper.so' at runtime to /tmp, bypassing NixOS RPATH patching.
  # It fails to resolve '_Unwind_RaiseException' due to missing libgcc_s.so.1.
  programs.steam.config.apps.sts2 = {
    id = id;
    launchOptions.preHook = ''
      export LD_PRELOAD="${pkgs.stdenv.cc.cc.lib}/lib/libgcc_s.so.1"
    '';
  };
  nixdots.persist.home = {
    directories = [
      ".local/share/SlayTheSpire2"
    ];
  };
}
