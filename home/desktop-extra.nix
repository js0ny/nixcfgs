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

    (myLib.scanPathsRec ../../modules/home/programs)
    ../../modules/home/programs/bottles.nix
    ../../modules/home/programs/browsers/qutebrowser.nix
    ../../modules/home/programs/cherry-studio.nix
    ../../modules/home/programs/easyeffects/module.nix
    ../../modules/home/programs/editors/emacs/module.nix
    ../../modules/home/programs/editors/helix.nix
    ../../modules/home/programs/editors/neovide.nix
    ../../modules/home/programs/editors/nvim/module.nix
    ../../modules/home/programs/editors/vscode/module.nix
    ../../modules/home/programs/editors/zed-editor/module.nix
    ../../modules/home/programs/element.nix
    ../../modules/home/programs/gh.nix
    ../../modules/home/programs/gwenview.nix
    ../../modules/home/programs/hermes-desktop/module.nix
    ../../modules/home/programs/libvirt.nix
    ../../modules/home/programs/magick.nix
    ../../modules/home/programs/media/beets.nix
    ../../modules/home/programs/media/cider-2.nix
    ../../modules/home/programs/media/feishin.nix
    ../../modules/home/programs/media/gallery-dl.nix
    ../../modules/home/programs/media/module.nix
    ../../modules/home/programs/media/picard.nix
    ../../modules/home/programs/mime.nix
    ../../modules/home/programs/productivity/anki.nix
    ../../modules/home/programs/productivity/goldendict.nix
    ../../modules/home/programs/productivity/libreoffice.nix
    ../../modules/home/programs/productivity/obsidian/module.nix
    ../../modules/home/programs/productivity/okular/module.nix
    ../../modules/home/programs/productivity/readest.nix
    ../../modules/home/programs/productivity/sdcv.nix
    ../../modules/home/programs/productivity/sioyek/module.nix
    ../../modules/home/programs/productivity/zotero.nix
    ../../modules/home/programs/protonmail-bridge.nix
    ../../modules/home/programs/protonvpn.nix
    ../../modules/home/programs/pwa/module.nix
    ../../modules/home/programs/qalculate.nix
    ../../modules/home/programs/quickemu.nix
    ../../modules/home/programs/shell/carapace.nix
    ../../modules/home/programs/swayimg.nix
    ../../modules/home/programs/terminals/alacritty.nix
    ../../modules/home/programs/terminals/ghostty.nix
    ../../modules/home/programs/terminals/kitty.nix
    ../../modules/home/programs/terminals/zellij/module.nix
    ../../modules/home/programs/vcs/module.nix
    ../../modules/home/programs/vibe-coding/module.nix
    # ../../modules/home/programs/newsflash.nix
    ../../modules/home/programs/wine.nix
    ../../modules/programs/gaming/celeste/module.nix
    ../../modules/programs/gaming/emulators/cemu.nix
    ../../modules/programs/gaming/emulators/retroarch.nix
    ../../modules/programs/gaming/emulators/ryujinx.nix
    ../../modules/programs/gaming/minecraft.nix
    ../modules/packages/extra.nix
    ../modules/packages/flatpak.nix
    ./desktop-base.nix
    ./desktop/niri
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
