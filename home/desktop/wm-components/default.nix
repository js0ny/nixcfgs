{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  wm = config.nixdots.desktop.wm;
in
{
  imports = [
    ./kanshi.nix
    ./polkit.nix
    ./systemd.nix
    ../../linux/desktop/noctalia-v5.nix
    inputs.dank-material-shell.homeModules.default
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
  services.cliphist.enable = (wm.clipboard == "cliphist");
}
