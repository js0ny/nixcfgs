{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./kanshi.nix
    ./polkit.nix
    ../../../modules/home/noctalia.nix
    inputs.noctalia.homeModules.default
  ];
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    localPkgs.power-profiles-next
    trash-cli
  ];
  home.sessionVariables = {
    ELECTRON_TRASH = "trash-cli";
    XAUTHORITY = "$XDG_RUNTIME_DIR/.XAuthority";
  };
}
