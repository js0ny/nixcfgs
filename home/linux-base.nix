{pkgs, ...}: {
  imports = [
    ./programs
    ../modules/home
    ../modules/home/linux.nix
  ];
  programs.nix-index.enable = true;
  programs.nix-index.symlinkToCacheHome = true;
  programs.nix-index-database.comma.enable = true;
}
