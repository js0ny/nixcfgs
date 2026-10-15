{
  pkgs,
  lib,
  inputs,
  config,
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
  flake-lock-reset-input = pkgs.writers.writeNuBin "flake-lock-reset-input" { } /* nu */ ''
    # Restore an input's pin from this repository's HEAD without changing other inputs.
    def main [input: string] {
      let head = (^${lib.getExe config.programs.git.package} show HEAD:./flake.lock | complete)
      if $head.exit_code != 0 {
        error make {msg: $head.stderr}
      }
      let previous = ($head.stdout | from json)
      let current = (open --raw flake.lock | from json)
      let previous_node = ($previous | get ([nodes $previous.root inputs $input] | into cell-path))
      let current_node = ($current | get ([nodes $current.root inputs $input] | into cell-path))
      if ($previous_node | describe) != "string" or ($current_node | describe) != "string" {
        error make {msg: "Cannot reset a following input"}
      }
      let locked = ($previous | get ([nodes $previous_node locked] | into cell-path))
      let restored = ($current
        | update ([nodes $current_node locked] | into cell-path) $locked
        | to json --indent 2)
      let temporary = (mktemp flake.lock.XXXXXXXX)
      try {
        $"($restored)\n" | save --raw --force $temporary
        mv --force $temporary flake.lock
      } catch {|err|
        rm --force $temporary
        error make {msg: $err.msg}
      }
    }
  '';
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
    js0ny.edstem-cli
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
    proton-cli
    rawtherapee
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

    inputs.artcraft.packages.${system}.photocraft
    inputs.artcraft.packages.${system}.pdfcraft
    inputs.artcraft.packages.${system}.lightcraft

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
