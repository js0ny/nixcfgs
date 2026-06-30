{
  flake.nixosModules.core =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # keep-sorted start
        bind
        curl
        dig
        ethtool
        file
        ghostty.terminfo
        git
        iw
        kitty.kitten
        kitty.terminfo
        lnav
        lsof
        moreutils
        psmisc
        socat
        wget
        # keep-sorted end
      ];

      # keep-sorted start
      networking.iproute2.enable = true;
      programs.iftop.enable = true;
      programs.iotop.enable = true;
      programs.less.enable = true;
      programs.mtr.enable = true;
      programs.nano.enable = false;
      programs.neovim.enable = true;
      programs.tcpdump.enable = true;
      # keep-sorted end

      programs.neovim = {
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        withNodeJs = false;
        withPython3 = false;
        withRuby = false;
      };

      environment.shellAliases = {
        grep = "grep --color=auto";
        ls = "ls --color=auto";
        ll = "ls -l";
        la = "ls -a";
      };
    };

  flake.darwinModules.core = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      iproute2mac
      # use gnu-compatible coreutils
      uutils-coreutils-noprefix
      uutils-findutils
      gnused
      gawk
      gnutar
      gzip
      getopt
      git
      mas
    ];
    nixdots.darwin.homebrew.formulae = [ "dark-mode" ];
  };
  flake.homeModules.core = { pkgs, ... }: {
    home.packages = with pkgs; [
      (writeShellApplication {
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
      })

      # keep-sorted start
      (ouch.override { enableUnfree = true; })
      # aria2
      ddgr
      hyperfine
      jq
      just
      localPkgs.rename-zero-pad
      miniserve
      moor
      p7zip
      pass
      rar
      rclone
      unar # For Non UTF-8 archives like gbk or sjis
      wget
      zoxide
      # keep-sorted end
    ];
  };
}
