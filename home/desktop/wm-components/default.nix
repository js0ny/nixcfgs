{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    # ../../walker.nix
    ./kanshi.nix
    ./polkit.nix
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
