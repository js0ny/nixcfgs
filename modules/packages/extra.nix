{ pkgs, lib, ... }:
let
  font-viewer = pkgs.writeShellScriptBin "font-viewer" ''
    exec ${pkgs.font-manager}/libexec/font-manager/font-viewer "$@"
  '';
  pdf2zh = pkgs.writeShellApplication {
    name = "pdf2zh";
    runtimeInputs = with pkgs; [
      uv
      stdenv.cc
    ];
    text = ''
      uvx --python=cp312 --from pdf2zh-next pdf2zh2 "$@"
    '';
  };
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
    dmg2img
    font-manager
    font-viewer
    fontforge
    gdb
    gh
    gimp
    godot
    godotpcktool
    goldendict-ng
    icoutils
    inkscape
    jetbrains.datagrip
    kdePackages.elisa
    kdePackages.isoimagewriter
    kdePackages.kdeconnect-kde
    kdePackages.kdenlive
    kdePackages.kleopatra
    kdePackages.partitionmanager
    kdePackages.qttools
    keepassxc
    krabby
    libguestfs
    misc.apps.limes
    misc.apps.proton-drive-cli
    misc.apps.ratune
    misc.apps.wdotool
    motrix-next
    nautilus
    newsflash
    nextcloud-client
    nmap
    octaveFull
    pdf2zh
    proton-pass
    rustscan
    sequoia-sq
    xournalpp
    # keep-sorted end

    # nix
    nixfmt
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

  programs.yazi.settings.plugin.prepend_previewers = [
    {
      url = "*.pck";
      run = "piper -- ${lib.getExe pkgs.godotpcktool} $1";
    }
  ];
}
