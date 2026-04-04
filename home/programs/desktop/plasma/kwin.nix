{lib, ...}: let
  iconFixRule = entryName: wmclass: {
    description = "Fix icon for ${entryName}";
    match = {
      # TODO: Add regex matching
      window-class = {
        value = wmclass;
        type = "exact";
      };
    };
    apply = {
      desktopfile = entryName;
    };
  };
  iconFixList = {
    "virt-manager" = "python3.13 .virt-manager-wrapped";
    "proton.vpn.app.gtk" = "python3.13 .protonvpn-app-wrapped";
  };
in {
  programs.plasma.window-rules =
    lib.mkForce (lib.mapAttrsToList iconFixRule iconFixList)
    // {
      "float mpv" = {
        description = "mpv float preset";
        match = {
          window-class = {
            value = "mpv";
            type = "exact";
          };
        };
        apply = {
          above = true;
        };
      };
    };
}
/*
TODO:
[a0cac373-462b-4b7e-a796-13e67404e7db]
Description=float - mpv
above=true
aboverule=3
opacityinactive=90
opacityinactiverule=2
skippagerrule=3
wmclass=mpv
wmclassmatch=1
*/

