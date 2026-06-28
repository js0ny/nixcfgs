{
  pkgs,
  config,
  secrets,
  myLib,
  inputs,
  ...
}:
{
  imports = [
    # keep-sorted start

    ../../modules/packages/extra.nix
    ../../modules/programs/gaming/celeste/module.nix
    ../../modules/programs/gaming/emulators/cemu.nix
    ../../modules/programs/gaming/emulators/retroarch.nix
    ../../modules/programs/gaming/emulators/ryujinx.nix
    ../../modules/programs/gaming/minecraft.nix
    ./desktop-base.nix
    # keep-sorted end

    inputs.self.homeModules.editors
    inputs.self.homeModules.emacs
    inputs.self.homeModules.flatpak
    inputs.self.homeModules.modern-unix
    inputs.self.homeModules.neovide
    inputs.self.homeModules.neovim
    inputs.self.homeModules.vcs-extra
    inputs.self.homeModules.vibe-coding
    inputs.self.homeModules.vscode
    inputs.self.homeModules.zed-editor
    inputs.self.homeModules.wakatime

    inputs.self.homeModules.alacritty
    inputs.self.homeModules.kitty
    inputs.self.homeModules.ghostty
    inputs.self.homeModules.zellij

    inputs.self.homeModules.gnome-keyring
    inputs.self.homeModules.discord
    inputs.self.homeModules.telegram
    inputs.self.homeModules.social-tencent
    inputs.self.homeModules.yazi

    inputs.self.homeModules.hermes-desktop
    inputs.self.homeModules.aichat
    inputs.self.homeModules.cherry-studio

    inputs.self.homeModules.anki
    inputs.self.homeModules.obsidian
    inputs.self.homeModules.zotero

    inputs.self.homeModules.mediatools
    inputs.self.homeModules.cider-2
    inputs.self.homeModules.feishin

    ../../modules/home/programs/element.nix
    ../../modules/home/programs/pcloud.nix
    ../../modules/home/programs/productivity/sdcv.nix
    ../../modules/home/programs/productivity/goldendict.nix
    ../../modules/home/programs/bottles.nix
    ../../modules/home/programs/wine.nix

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
