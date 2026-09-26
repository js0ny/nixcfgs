{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    bind
    curl
    dig
    ethtool
    file
    ghostty.terminfo
    gitMinimal
    iw
    kitty.kitten
    kitty.terminfo
    linuxPackages.turbostat
    lnav
    lsof
    moreutils
    psmisc
    python3
    socat
    sysstat # iostat
    wget
    # keep-sorted end
    (pkgs.neovim.override {
      waylandSupport = config.hardware.graphics.enable;
      withNodeJs = false;
      withPython3 = false;
      withRuby = false;
      viAlias = true;
      vimAlias = true;
    })
  ];

  # keep-sorted start block=yes
  networking.iproute2.enable = true;
  programs.iftop.enable = true;
  programs.iotop.enable = true;
  programs.less.enable = true;
  programs.mtr.enable = true;
  programs.nano.enable = false;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.tcpdump.enable = true;
  # keep-sorted end

  environment.shellAliases = {
    grep = "grep --color=auto";
    ls = "ls --color=auto";
    ll = "ls -l";
    la = "ls -a";
  };
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
  };
}
