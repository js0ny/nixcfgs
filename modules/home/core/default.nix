{ config, ... }:
{
  imports = [
    # keep-sorted start
    ./antidots.nix
    ./do-not-track.nix
    ./gpg.nix
    ./sops.nix
    ./ssh.nix
    ./xdg-dirs.nix
    # keep-sorted end
  ];
  home.username = config.nixdots.user.name;
  home.homeDirectory = config.nixdots.user.home;

  programs.home-manager.enable = true;

  xdg.binHome = "${config.home.homeDirectory}/.local/bin";
  xdg.localBinInPath = true;

  nixdots.persist.home = {
    directories = [
      ".ssh"
    ];
  };
}
