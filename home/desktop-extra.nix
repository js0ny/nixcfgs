{ pkgs, config, ... }:
{
  imports = [
    # keep-sorted start

    ./desktop-base.nix
    ./desktop/niri
    ./gaming
    ./gaming/celeste
    ./gaming/emulators/cemu.nix
    ./gaming/emulators/retroarch.nix
    ./gaming/emulators/ryujinx.nix
    ./gaming/minecraft.nix
    ./gaming/steam
    ./packages/flatpak.nix
    ./programs
    ./programs/bottles.nix
    ./programs/browsers/chromium.nix
    ./programs/browsers/firefox
    ./programs/cherry-studio.nix
    ./programs/claude-code.nix
    ./programs/codex.nix
    ./programs/easyeffects
    ./programs/editors/emacs.nix
    ./programs/editors/neovide.nix
    ./programs/editors/nvim
    ./programs/editors/vscode
    ./programs/editors/zed-editor
    ./programs/element.nix
    ./programs/eza.nix
    ./programs/gwenview.nix
    ./programs/libvirt.nix
    ./programs/magick.nix
    ./programs/media
    ./programs/media/beets.nix
    ./programs/media/cider-2.nix
    ./programs/media/feishin.nix
    ./programs/media/gallery-dl.nix
    ./programs/media/picard.nix
    ./programs/mime.nix
    ./programs/productivity/anki.nix
    ./programs/productivity/goldendict.nix
    ./programs/productivity/libreoffice.nix
    ./programs/productivity/obsidian
    ./programs/productivity/readest.nix
    ./programs/productivity/sdcv.nix
    ./programs/productivity/sioyek
    ./programs/productivity/zoom-us.nix
    ./programs/productivity/zotero.nix
    ./programs/protonmail-bridge.nix
    ./programs/quickemu.nix
    ./programs/rime
    ./programs/shell/bash.nix
    ./programs/shell/carapace.nix
    ./programs/shell/fish
    ./programs/shell/nu.nix
    ./programs/shell/zsh.nix
    ./programs/terminals/ghostty.nix
    ./programs/terminals/kitty.nix
    ./programs/terminals/zellij.nix
    # ./programs/newsflash.nix
    ./programs/wine.nix
    # keep-sorted end
  ];
  programs.pdf2zh.enable = true;
  home.packages = with pkgs; [
    (jetbrains.datagrip.override {
      vmopts = "-Dawt.toolkit.name=WLToolkit";
    })
    # keep-sorted start
    awscli2
    blender
    calibre
    gh
    gimp
    kdePackages.elisa
    kdePackages.kdeconnect-kde
    kdePackages.kdenlive
    # PDF Viewer
    kdePackages.okular
    kdePackages.qttools
    kicad
    krabby
    localPkgs.BBDown
    localPkgs.danmaku2ass
    newsflash
    octaveFull
    rustdesk
    tor-browser
    # keep-sorted end
  ];

  xdg.configFile."krabby/config.toml".text = ''
    language = "en"
    shiny_rate = 0.0078125
  '';
  catppuccin.thunderbird.profile = config.home.username;
}
