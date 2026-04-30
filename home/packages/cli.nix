{
  pkgs,
  config,
  ...
}:
{
  programs.btop.enable = true;
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
  };
  programs.lazygit = {
    enable = true;
    settings = {
      git.pagers =
        if config.programs.delta.enable then [ { pager = "delta --dark --paging=never"; } ] else [ ];
    };
  };

  programs.jujutsu.enable = true;

  programs.zed-editor.extensions = [
    "make"
    "just"
    "git-firefly"
  ];

  home.packages =
    with pkgs;
    [
      gnumake
      rclone
      age
      chezmoi
      curlie
      duf
      dust
      fd
      ffmpeg
      glow
      hyperfine
      just
      procs
      ripgrep
      ripgrep-all
      wget
      git
      fastfetch
      zoxide
      # Misc ta-lib ddgr protonvpn-cli
      miniserve
      jq
      ddgr
      aria2
      pass
      deploy-rs
      localPkgs.rename-zero-pad
      openssl
      rip2

      # Archiving
      p7zip
      # rar: Unfree, the only way (afaik) to unarchive some very old partition rars
      rar
      unar # For Non UTF-8 archives like gbk or sjis
      # rar support requires unfree flag.
      (ouch.override { enableUnfree = true; })
    ]
    ++ (
      if pkgs.stdenv.isDarwin then
        with pkgs; [ duti ]
      else
        with pkgs;
        [
          steam-run
          proton-vpn-cli
          # https://github.com/NixOS/nixpkgs/pull/513252
          srm
          podman-compose
        ]
    );
}
