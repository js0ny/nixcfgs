{pkgs, ...}: {
  imports = [
    ./linux-base.nix
  ];
  home.packages = with pkgs; [
    kitty
    openssl
  ];
}
