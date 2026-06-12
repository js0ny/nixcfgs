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
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
  };
  # minimal alias for root environment
  environment.shellAliases = {
    grep = "grep --color=auto";
    ls = "ls --color=auto";
    ll = "ls -l";
    la = "ls -a";
  };

}
