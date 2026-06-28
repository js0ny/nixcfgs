{
  pkgs,
  config,
  secrets,
  myLib,
  ...
}:
{
  imports = [
    # keep-sorted start

    ../../modules/programs/gaming/celeste/module.nix
    ../../modules/programs/gaming/emulators/cemu.nix
    ../../modules/programs/gaming/emulators/retroarch.nix
    ../../modules/programs/gaming/emulators/ryujinx.nix
    ../../modules/programs/gaming/minecraft.nix
    ../modules/packages/extra.nix
    ../modules/packages/flatpak.nix
    ./desktop-base.nix
    ./desktop/niri
    ./programs
    ./programs/bottles.nix
    ./programs/browsers/qutebrowser.nix
    ./programs/cherry-studio.nix
    ./programs/easyeffects
    ./programs/editors/emacs
    ./programs/editors/helix.nix
    ./programs/editors/neovide.nix
    ./programs/editors/nvim
    ./programs/editors/vscode
    ./programs/editors/zed-editor
    ./programs/element.nix
    ./programs/gh.nix
    ./programs/gwenview.nix
    ./programs/hermes-desktop
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
    ./programs/productivity/okular
    ./programs/productivity/readest.nix
    ./programs/productivity/sdcv.nix
    ./programs/productivity/sioyek
    ./programs/productivity/zotero.nix
    ./programs/protonmail-bridge.nix
    ./programs/protonvpn.nix
    ./programs/pwa
    ./programs/qalculate.nix
    ./programs/quickemu.nix
    ./programs/shell/carapace.nix
    ./programs/swayimg.nix
    ./programs/terminals/alacritty.nix
    ./programs/terminals/ghostty.nix
    ./programs/terminals/kitty.nix
    ./programs/terminals/zellij
    ./programs/vcs
    ./programs/vibe-coding
    # ./programs/newsflash.nix
    ./programs/wine.nix
    # keep-sorted end
  ];
  programs.pdf2zh.enable = true;

  catppuccin.thunderbird.profile = config.home.username;

  nixdots.sops.secrets = {
    nix_github_pat = {
      env = [ "NIX_CONFIG" ];
      sopsFile = secrets + /hosts.yaml;
    };
  };
}
