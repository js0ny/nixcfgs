{ pkgs, ... }: {
  imports = [
    ./extra-persist.nix
    ./extra-dconf.nix
  ];

  home.packages = with pkgs; [
    jetbrains.datagrip
    # keep-sorted start
    awscli2
    blender
    calibre
    freecad
    gdb
    gh
    gimp
    icoutils
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
