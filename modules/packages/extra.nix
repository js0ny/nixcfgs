{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  flakeRoot = inputs.self.outPath;
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
  flake-lock-reset-input = pkgs.writers.writeNuBin "flake-lock-reset-input" { } (
    builtins.readFile "${flakeRoot}/.bin/flake-lock-reset-input.nu"
  );
  nixpkgs-pr-tracker = pkgs.writers.writeNuBin "nixpkgs-pr-tracker" { } (
    builtins.readFile "${flakeRoot}/.bin/nixpkgs-pr-tracker.nu"
  );
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
    # godot
    godotpcktool
    goldendict-ng
    himalaya
    icoutils
    inkscape
    inputs.artcraft.packages.${system}.lightcraft
    inputs.artcraft.packages.${system}.pdfcraft
    inputs.artcraft.packages.${system}.photocraft
    inputs.dbx.packages.${system}.default
    js0ny.dirstat-rs
    js0ny.edstem-cli
    js0ny.m365
    js0ny.proton-drive-cli
    js0ny.ratune
    js0ny.wdotool
    kdePackages.isoimagewriter
    kdePackages.kdenlive
    kdePackages.kleopatra
    kdePackages.partitionmanager
    kdePackages.qttools
    keepassxc
    krabby
    marktext
    mission-center
    nautilus
    newsflash
    nmap
    octaveFull
    pdf2zh
    pikpaktui
    pkgsStable.python314Packages.huggingface-hub
    poppler-utils
    proton-cli
    rawtherapee
    rayburst
    rustscan
    sequoia-sq
    super-productivity
    tinymist
    tor-browser
    tradingview
    tsukimi
    typst
    woxi
    xournalpp
    # keep-sorted end

    # nix
    nixfmt
    nix-diff
    nix-output-monitor
    nvd
    flake-lock-reset-input
    nixpkgs-pr-tracker

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
