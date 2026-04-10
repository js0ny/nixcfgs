{
  pkgs,
  lib,
  ...
}:
let
  toINI = lib.generators.toINI;
in
{
  xdg.dataFile."Steam/steamapps/common/Expedition 33/Sandfall/Binaries/Win64" = {
    source = pkgs.localPkgs.ClairObscurFix;
    recursive = true;
  };
  programs.steam.config.apps.expedition33 = {
    id = 1903340;
    launchOptions = {
      env.WINEDLLOVERRIDES = "dsound=n,b";
    };
  };
  xdg.dataFile."Steam/steamapps/common/Expedition 33/Sandfall/Binaries/Win64/ClairObscurFix.ini" = {
    text = toINI { } {
      "Developer Console" = {
        Enabled = false;
      };

      "Skip Intro Logos" = {
        Enabled = true;
      };

      "Uncap Cutscene FPS" = {
        Enabled = true;
        AllowFrameGen = false;
      };

      "Adjust Resolution Checks" = {
        Enabled = true;
      };

      "Maximum Timer Resolution" = {
        Enabled = true;
      };

      "Cutscenes" = {
        DisableLetterboxing = false;
        DisablePillarboxing = true;
      };

      "Fix Movies" = {
        Enabled = true;
      };

      "Disable Subtitle Blur" = {
        Enabled = false;
      };

      "Sharpening" = {
        Strength = 0;
      };
    };
    force = true;
  };
}
