# ~/.config/nix-config/common/packages-headless.nix
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
      srm
      ddgr
      aria2
      p7zip
      pass
      # rar: Unfree, the only way (afaik) to unarchive some very old partition rars
      rar
      deploy-rs
      # rar support requires unfree flag.
      (ouch.override { enableUnfree = true; })
      localPkgs.rename-zero-pad
      nix-diff
      openssl
    ]
    ++ (
      if pkgs.stdenv.isDarwin then
        with pkgs; [ duti ]
      else
        with pkgs;
        [
          steam-run
          proton-vpn-cli
        ]
    );
}
