{
  pkgs,
  config,
  ...
}:
let
  hmmkbak = pkgs.writeShellApplication {
    name = "hmmkbak";
    text = ''
      if (($# != 1)); then
        echo "Make a backup of a file from symlink (in /nix/store)"
        echo "Usage: $0 <file>" >&2
        exit 1
      fi
      if [[ ! -L "$1" ]]; then
        echo "Error: $1 is not a symlink" >&2
        exit 1
      fi
      mv "$1" "$1.bak"
      cp --dereference "$1.bak" "$1"
      chmod 777 "$1"
    '';
  };
in
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
      # aria2
      chezmoi
      curlie
      ddgr
      fd
      git
      glow
      gnumake
      hmmkbak
      hyperfine
      jq
      just
      localPkgs.rename-zero-pad
      miniserve
      moor
      p7zip
      pass
      procs
      rar
      rclone
      rip2
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
