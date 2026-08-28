{
  imports = [
    ./noctalia.nix
    ./wm-polkit.nix
    ./shikane.nix
  ];
  flake.homeModules.wm-components =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        brightnessctl
        trash-cli
        grim
        slurp
        satty
        mpvpaper
      ];
      home.sessionVariables = {
        ELECTRON_TRASH = "trash-cli";
        XAUTHORITY = "$XDG_RUNTIME_DIR/.XAuthority";
      };
    };
}
