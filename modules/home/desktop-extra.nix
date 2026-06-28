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
    inputs.self.homeModules.flatpak
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
