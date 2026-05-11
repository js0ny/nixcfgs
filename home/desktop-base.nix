{
  lib,
  config,
  ...
}:
{
  imports = [
    # keep-sorted start

    ./desktop/niri
    ./gaming/emulators/retroarch.nix
    ./linux-base.nix
    ./packages/devtools.nix
    ./packages/gui.nix
    ./programs
    ./programs/aichat.nix
    ./programs/browsers/firefox
    ./programs/dolphin
    ./programs/editors/nvim
    ./programs/editors/vscode
    ./programs/fsearch.nix
    ./programs/loupe.nix
    ./programs/media/feishin.nix
    ./programs/media/mpv.nix
    ./programs/mime.nix
    ./programs/miniserve.nix
    ./programs/nix-index.nix
    ./programs/opencode
    ./programs/pcloud.nix
    ./programs/pim.nix
    ./programs/productivity/anki.nix
    ./programs/productivity/obsidian
    ./programs/productivity/readest.nix
    ./programs/productivity/sdcv.nix
    ./programs/productivity/sioyek
    ./programs/sandboxed.nix
    ./programs/shell/bash.nix
    ./programs/shell/direnv.nix
    ./programs/shell/fish
    ./programs/shell/nu.nix
    ./programs/shell/zsh.nix
    ./programs/social/discord.nix
    ./programs/social/qq.nix
    ./programs/social/telegram.nix
    ./programs/social/wechat.nix
    ./programs/terminals/kitty.nix
    ./programs/terminals/tmux.nix
    # ./programs/walker.nix
    ./programs/url-dispatcher.nix
    ./programs/vicinae.nix
    # keep-sorted end
  ];

  nixdots.persist.home = {
    directories = [
      ".local/state/wireplumber"
    ];
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

  catppuccin.cache.enable = true;
}
