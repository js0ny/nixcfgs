{ pkgs, ... }: {
  home.packages = with pkgs; [
    proton-pass-cli
    proton-pass
  ];
  js0ny.persist.stores.state.directories = [
    ".config/Proton Pass"
    ".local/share/proton-pass-cli"
  ];
}
