{ pkgs, lib, ... }:
let
  setwall = pkgs.writeShellScriptBin "setwall" ''
    if [[ $XDG_CURRENT_DESKTOP == "Hyprland" || $XDG_CURRENT_DESKTOP == "niri" ]]; then
      noctalia msg wallpaper-set "$@"
    elif [[ $XDG_CURRENT_DESKTOP == "KDE" ]]; then
      plasma-apply-wallpaperimage "$@"
    elif [[ $XDG_CURRENT_DESKTOP == "GNOME" ]]; then
      dconf write /org/gnome/desktop/background/picture-uri "file://$@"
    fi
  '';
  setwall-darwin = pkgs.writeShellScriptBin "setwall" ''
    osascript -e 'on run {img}' -e 'tell application "System Events" to set picture of every desktop to img' -e 'end run'
  '';
in
{
  home.packages = if pkgs.stdenv.hostPlatform.isDarwin then [ setwall-darwin ] else [ setwall ];
  programs.yazi.settings = {
    open.prepend_rules = [
      {
        mime = "image/*";
        use = [
          "open"
          "reveal"
          "set-wallpaper"
        ];
      }
    ];
    opener = {
      set-wallpaper = [
        {
          run = "${lib.getExe setwall} %s1";
          desc = "Set as wallpaper";
          for = "linux";

        }
        {
          run = /* bash */ "${lib.getExe setwall-darwin} %s1";
          desc = "Set as wallpaper";
          for = "macos";
        }
      ];
    };
  };
}
