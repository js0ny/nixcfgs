# ~/.config/nix-config/common/packages-headless.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    bind
    curl
    dig
    file
    git
    lsof
    moreutils
    psmisc
    socat
    tmux
    vim
    wget
    # keep-sorted end
  ];
  # Explicitly define default EDITOR
  programs.nano.enable = false;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };
  programs.mtr.enable = true;
  programs.tcpdump.enable = true;
  programs.iotop.enable = true;
  programs.iftop.enable = true;
}
