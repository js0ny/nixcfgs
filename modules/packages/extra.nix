{ pkgs, ... }:
let
  font-viewer = pkgs.writeShellScriptBin "font-viewer" ''
    exec ${pkgs.font-manager}/libexec/font-manager/font-viewer "$@"
  '';
in
{
  imports = [
    ./extra-persist.nix
    ./extra-dconf.nix
  ];

  home.packages = with pkgs; [
    # keep-sorted start
    awscli2
    blender
    bruno
    bruno-cli
    calibre
    clapper
    dmg2img
    font-manager
    font-viewer
    fontforge
    gdb
    gh
    gimp
    goldendict-ng
    icoutils
    inkscape
    jetbrains.datagrip
    kdePackages.elisa
    kdePackages.isoimagewriter
    kdePackages.kdeconnect-kde
    kdePackages.kdenlive
    kdePackages.partitionmanager
    kdePackages.qttools
    krabby
    libguestfs
    misc.apps.proton-drive-cli
    motrix-next
    nautilus
    newsflash
    nmap
    octaveFull
    proton-pass
    showtime
    texmacs
    xournalpp
    # keep-sorted end

    # nix
    nix-diff
    nix-output-monitor
    nvd
    nix-tree
    deploy-rs
    nurl
    nvfetcher
    npins
    nil
    nixd
    cachix
  ];
  home.sessionVariables = {
    GOLDENDICT_FORCE_WAYLAND = 1;
  };
}
