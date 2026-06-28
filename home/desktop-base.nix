{
  lib,
  config,
  ...
}:
{
  imports = [
    # keep-sorted start

    ../../modules/programs/gaming/emulators/retroarch.nix
    ../modules/packages/devtools.nix
    ../modules/packages/flatpak.nix
    ../modules/packages/gui.nix
    ./desktop/niri
    ./linux-base.nix
    ./programs
    ./programs/aichat.nix
    # ./programs/walker.nix
    ./programs/browsers/url-dispatcher.nix
    ./programs/editors/vscode
    # ./programs/fsearch.nix # use vicinae
    ./programs/loupe.nix
    ./programs/media/feishin.nix
    ./programs/media/mpv.nix
    ./programs/mime.nix
    ./programs/miniserve.nix
    ./programs/nix-index.nix
    ./programs/pcloud.nix
    ./programs/pim.nix
    ./programs/productivity/anki.nix
    ./programs/productivity/obsidian
    ./programs/productivity/readest.nix
    ./programs/productivity/sdcv.nix
    ./programs/productivity/sioyek
    ./programs/sandboxed.nix
    ./programs/shell/direnv.nix
    ./programs/social/discord.nix
    ./programs/social/qq.nix
    ./programs/social/telegram.nix
    ./programs/social/wechat.nix
    ./programs/terminals/kitty.nix
    ./programs/terminals/tmux.nix
    # keep-sorted end
  ];

  nixdots.persist.nosnap.home = {
    directories = [ ".local/state/wireplumber" ];
  };

  nixdefs = {
    acp.enable = true;
    llm.enable = true;
    mcp.enable = true;
    hardware.enable = true;
  };

  # Hidden directories under $HOME
  home.file.".hidden".text = lib.concatStringsSep "\n" [
    "PDX"
  ];

}
