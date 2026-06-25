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
    ../programs/dconf-editor.nix
  ];

  home.packages = with pkgs; [
    # keep-sorted start

    awscli2
    blender
    calibre
    clapper
    dmg2img
    font-manager
    font-viewer
    fontforge
    freecad
    gdb
    gh
    gimp
    gtkwave
    icoutils
    inkscape
    jetbrains.datagrip
    kdePackages.elisa
    kdePackages.isoimagewriter
    kdePackages.kdeconnect-kde
    kdePackages.kdenlive
    kdePackages.partitionmanager
    kdePackages.qttools
    kicad
    krabby
    libguestfs
    llm-agents.agentsview
    llm-agents.ccusage
    logisim-evolution
    ltspice
    misc.apps.proton-drive-cli
    motrix-next
    nautilus
    newsflash
    ngspice
    nmap
    nur.repos.Ev357.helium
    octaveFull
    openscad
    openscad-lsp
    picocom
    proton-pass
    prusa-slicer
    pulseview
    qucs-s
    showtime
    tea
    texmacs
    xournalpp
    # keep-sorted end
  ];
}
