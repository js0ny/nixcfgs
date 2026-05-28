{ config, inputs, ... }:
{
  imports = [
    ../../home/wsl.nix
    # keep-sorted start

    ./vars.nix
    # ./openclaw
    # keep-sorted end

    # keep-sorted start
    inputs.betterfox-nix.modules.homeManager.betterfox
    inputs.catppuccin.homeModules.catppuccin
    inputs.nix-index-database.homeModules.nix-index
    inputs.sops-nix.homeManagerModules.sops
    # keep-sorted end
  ];

  home.sessionVariables = {
    TO_AV1_CRF = "32";
    TO_AV1_PRESET = "8";
    TO_AV1_MP4_CRF = "32";
    TO_AV1_MP4_PRESET = "8";
    TO_AV1_MP4_AUDIO_BITRATE = "192k";
    TO_AVIF_QUALITY = "85";
    TO_WEBP_QUALITY = "85";
  };

  nixdefs.llm.enable = true;

  home.stateVersion = "26.05";

  home.customDirs = {
    wallpaper = "${config.home.homeDirectory}/Wallpaper";
    screenshots = "${config.xdg.cacheHome}/Captures/Screenshots";
    screencasts = "${config.xdg.cacheHome}/Captures/Screencasts";
  };

}
