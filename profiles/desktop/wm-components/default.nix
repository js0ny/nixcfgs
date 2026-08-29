{
  imports = [
    ./noctalia.nix
    ./shikane.nix
  ];
  flake.homeModules.wm-components =
    { pkgs, ... }:
    {
      imports = [ ./wm-polkit.nix ];
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
