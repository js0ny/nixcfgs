{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  pkgsStable = pkgs.mv.at "26.05";
  font-manager = pkgsStable.font-manager;
  font-viewer = pkgs.writeShellScriptBin "font-viewer" ''
    exec ${font-manager}/libexec/font-manager/font-viewer "$@"
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
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [
    ./extra-persist.nix
    ./extra-dconf.nix
  ];

  home.packages = with pkgs; [
    # keep-sorted start block=yes
    # (comfyui.override {
    #   python3 = pkgs.python3.override {
    #     packageOverrides = pyFinal: pyPrev: {
    #       torch = pyPrev.torch.override {
    #         cudaSupport = true;
    #       };
    #       triton = pyPrev.triton.override {
    #         cudaSupport = true;
    #       };
    #     };
    #   };
    # })
    (darktable.override { withAi = true; })
    ashpd-demo # for portal debug
    awscli2
    blender
    bruno
    bruno-cli
    calibre
    dmg2img
    dnscontrol
    ffsend
    font-manager
    font-viewer
    fontforge
    gcx # grafana cli
    gdb
    gh
    gimp
    godot
    godotpcktool
    goldendict-ng
    himalaya
    icoutils
    inkscape
    js0ny.dirstat-rs
    js0ny.limes
    js0ny.m365
    js0ny.proton-drive-cli
    js0ny.ratune
    js0ny.tty7-src
    js0ny.wdotool
    js0ny.xdd
    kdePackages.isoimagewriter
    kdePackages.kdenlive
    kdePackages.kleopatra
    kdePackages.partitionmanager
    kdePackages.qttools
    keepassxc
    krabby
    marktext
    mission-center
    motrix-next
    nautilus
    newsflash
    nmap
    octaveFull
    pdf2zh
    pikpaktui
    pkgsStable.python314Packages.huggingface-hub
    poppler-utils
    rawtherapee
    rustscan
    sequoia-sq
    super-productivity
    tinymist
    tradingview
    tsukimi
    typst
    xournalpp
    # keep-sorted end

    # nix
    nixfmt
    nix-diff
    nix-output-monitor
    nvd

    inputs.nix-tree-rs.packages.${system}.default
    inputs.fast-nix-gc.packages.${system}.default
    deploy-rs
    nurl
    nvfetcher
    npins
    hydra-check
    nil
    nixd
    cachix
    alejandra
    manix
    nix-auth
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
  xdg.configFile."gdb/gdbinit".text = ''
    add-auto-load-safe-path /nix/store/*/lib
  '';

  programs.posting = {
    enable = true;
    package = pkgsStable.posting;
  };
  js0ny.flatpak.packages = [
    "com.rustdesk.RustDesk"
  ];
}
