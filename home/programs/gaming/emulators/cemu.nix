{pkgs, ...}: {
  home.packages = with pkgs; [
    # WiiU Emulator
    cemu
  ];
}
