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

    ./desktop-base.nix
    ../../modules/desktop/home/niri/module.nix
    ../../modules/programs/gaming/celeste/module.nix
    ../../modules/programs/gaming/emulators/cemu.nix
    ../../modules/programs/gaming/emulators/retroarch.nix
    ../../modules/programs/gaming/emulators/ryujinx.nix
    ../../modules/programs/gaming/minecraft.nix
    ../../modules/packages/extra.nix
    ../../modules/packages/flatpak.nix
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
