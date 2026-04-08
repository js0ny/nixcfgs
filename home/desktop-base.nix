{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./base.nix
    ./packages/gui.nix
    ./packages/devtools.nix
    ./programs

    ./programs/opencode

    ./programs/block-desktop-entries.nix
    ./programs/mime.nix

    ./programs/browsers/firefox
    ./programs/desktop/wayland-wm/niri

    ./programs/editors/nvim
    ./programs/editors/vscode.nix

    ./gaming/emulators/retroarch.nix

    ./programs/media/feishin.nix
    ./programs/media/mpv.nix

    ./programs/terminals/kitty.nix
    ./programs/terminals/tmux.nix

    ./programs/shell/bash.nix
    ./programs/shell/zsh.nix
    ./programs/shell/fish.nix
    ./programs/shell/direnv.nix

    ./programs/social/discord.nix
    ./programs/social/telegram.nix
    ./programs/social/wechat.nix

    ./programs/aichat.nix
    ./programs/dolphin
    ./programs/fsearch.nix
    ./programs/miniserve.nix
    ./programs/pcloud.nix
    ./programs/sandboxed.nix
    ./programs/walker.nix

    ./programs/productivity/obsidian
    ./programs/productivity/sioyek
    ./programs/productivity/anki.nix
    ./programs/productivity/readest.nix
    ./programs/productivity/sdcv.nix
  ];
  home.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };
  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
}
