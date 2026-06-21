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
    calibre
    font-manager
    font-viewer
    fontforge
    freecad
    gdb
    gh
    gimp
    icoutils
    jetbrains.datagrip
    kdePackages.elisa
    kdePackages.isoimagewriter
    kdePackages.kdeconnect-kde
    kdePackages.kdenlive
    kdePackages.partitionmanager
    kdePackages.qttools
    kicad
    krabby
    llm-agents.agentsview
    llm-agents.ccusage
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
    qucs-s
    tea
    # keep-sorted end
  ];
}
