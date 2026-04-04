{pkgs, ...}: {
  imports = [
    ./base.nix
  ];
  home.packages = with pkgs; [
    kitty
    openssl
  ];
}
