{ pkgs, ... }:
{
  imports = [
    ./desktop-base.nix
    ./programs
    ./packages/flatpak.nix

    ./programs/browsers/firefox
    ./programs/browsers/chromium.nix

    ./programs/desktop/wayland-wm/niri
    # ./programs/desktop/plasma

    ./programs/editors/zed-editor
    ./programs/editors/emacs.nix
    ./programs/editors/vscode.nix
    ./programs/editors/nvim
    ./programs/editors/neovide.nix

    ./gaming
    ./gaming/steam
    ./gaming/celeste
    ./gaming/minecraft.nix
    ./gaming/emulators/retroarch.nix
    ./gaming/emulators/cemu.nix
    ./gaming/emulators/ryujinx.nix

    ./programs/media
    ./programs/media/cider-2.nix
    ./programs/media/gallery-dl.nix
    ./programs/media/beets.nix
    ./programs/media/feishin.nix
    ./programs/media/picard.nix

    ./programs/terminals/kitty.nix
    ./programs/terminals/ghostty.nix
    ./programs/terminals/zellij.nix

    ./programs/shell/bash.nix
    ./programs/shell/zsh.nix
    ./programs/shell/fish
    ./programs/shell/carapace.nix
    ./programs/shell/nu.nix

    ./programs/mime.nix
    ./programs/block-desktop-entries.nix

    ./programs/gwenview.nix
    ./programs/libvirt.nix
    ./programs/magick.nix
    # ./programs/newsflash.nix
    ./programs/ollama.nix
    ./programs/wine.nix
    ./programs/bottles.nix
    ./programs/eza.nix
    ./programs/cherry-studio.nix
    ./programs/element.nix
    ./programs/codex.nix
    ./programs/claude-code.nix
    ./programs/protonmail-bridge.nix
    ./programs/quickemu.nix

    ./programs/devenvs/typst.nix
    ./programs/devenvs/lua.nix
    ./programs/devenvs/nix.nix

    ./programs/easyeffects

    ./programs/productivity/obsidian
    ./programs/productivity/sioyek
    ./programs/productivity/anki.nix
    ./programs/productivity/libreoffice.nix
    ./programs/productivity/onlyoffice.nix
    ./programs/productivity/goldendict.nix
    ./programs/productivity/readest.nix
    ./programs/productivity/sdcv.nix
    ./programs/productivity/thunderbird.nix
    ./programs/productivity/zotero.nix
    ./programs/productivity/zoom-us.nix

    ./programs/rime
  ];
  programs.pdf2zh.enable = true;
  home.packages = with pkgs; [
    blender
    kdePackages.kdenlive
    # PDF Viewer
    kdePackages.okular
    gimp
    kicad
    kdePackages.kdeconnect-kde
    rustdesk
    kdePackages.qttools
    calibre
    kdePackages.elisa
    (jetbrains.clion.override {
      vmopts = "-Dawt.toolkit.name=WLToolkit";
    })
    (jetbrains.datagrip.override {
      vmopts = "-Dawt.toolkit.name=WLToolkit";
    })
    nix-output-monitor
    nvd
    localPkgs.BBDown
    localPkgs.danmaku2ass
    octaveFull
    krabby
  ];
  # ++ (pkgs.mkElectronWayland [
  #   pkgs.cider-2
  # ]);

  xdg.configFile."krabby/config.toml".text = ''
    language = "en"
    shiny_rate = 0.0078125
  '';
}
