{
  lib,
  config,
  ...
}:
{
  imports = [
    # keep-sorted start

    ../../modules/desktop/home/niri/module.nix
    ../../modules/home/programs/aichat.nix
    # ../../modules/home/programs/walker.nix
    ../../modules/home/programs/browsers/url-dispatcher.nix
    ../../modules/home/programs/editors/vscode/module.nix
    # ../../modules/home/programs/fsearch.nix # use vicinae
    ../../modules/home/programs/loupe.nix
    ../../modules/home/programs/media/feishin.nix
    ../../modules/home/programs/media/mpv.nix
    ../../modules/home/programs/mime.nix
    ../../modules/home/programs/miniserve.nix
    ../../modules/home/programs/nix-index.nix
    ../../modules/home/programs/pcloud.nix
    ../../modules/home/programs/pim.nix
    ../../modules/home/programs/productivity/anki.nix
    ../../modules/home/programs/productivity/obsidian/module.nix
    ../../modules/home/programs/productivity/readest.nix
    ../../modules/home/programs/productivity/sdcv.nix
    ../../modules/home/programs/productivity/sioyek/module.nix
    ../../modules/home/programs/sandboxed.nix
    ../../modules/home/programs/shell/direnv.nix
    ../../modules/home/programs/social/discord.nix
    ../../modules/home/programs/social/qq.nix
    ../../modules/home/programs/social/telegram.nix
    ../../modules/home/programs/social/wechat.nix
    ../../modules/home/programs/terminals/kitty.nix
    ../../modules/home/programs/terminals/tmux.nix
    ../../modules/programs/gaming/emulators/retroarch.nix
    ../modules/packages/devtools.nix
    ../modules/packages/flatpak.nix
    ../modules/packages/gui.nix
    ./linux-base.nix
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
