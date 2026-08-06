{ pkgs, ... }: {
  home.packages = with pkgs; [
    proton-pass-cli
    proton-pass
  ];
  nixdots.persist.home.directories = [
    ".config/Proton Pass"
    ".local/share/proton-pass-cli"
  ];
}
