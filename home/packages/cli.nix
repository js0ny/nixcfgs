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
      # keep-sorted start

      # rar support requires unfree flag.
      (ouch.override { enableUnfree = true; })
      age
      aria2
      chezmoi
      curlie
      ddgr
      deploy-rs
      duf
      dust
      fd
      git
      glow
      gnumake
      hyperfine
      jq
      just
      localPkgs.rename-zero-pad
      # Misc ta-lib ddgr protonvpn-cli
      miniserve
      openssl
      # Archiving
      p7zip
      pass
      procs
      # rar: Unfree, the only way (afaik) to unarchive some very old partition rars
      rar
      rclone
      rip2
      ripgrep
      srm
      unar # For Non UTF-8 archives like gbk or sjis
      wget
      zoxide
      # keep-sorted end
    ]
    ++ (
      if pkgs.stdenv.isDarwin then
        with pkgs; [ duti ]
      else
        with pkgs;
        [
          podman-compose
        ]
    );
}
