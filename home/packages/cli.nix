{
  pkgs,
  config,
  ...
}:
{
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
    };
    package = pkgs.btop.override {
      cudaSupport = config.nixdots.linux.gpu == "nvidia";
    };
  };
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

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = config.nixdots.user.name;
        email = config.nixdots.user.email;
      };
    };
  };

  programs.zed-editor.extensions = [
    "make"
    "just"
    "git-firefly"
  ];

  home.packages =
    with pkgs;
    [
      # keep-sorted start

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
      miniserve
      moor
      openssl
      p7zip
      pass
      procs
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
        with pkgs;
        [
          duti
          mas
        ]
      else
        with pkgs;
        [
          podman-compose
        ]
    );

  nixdots.darwin.homebrew.formulae = [ "dark-mode" ];
}
