# ~/.config/nix-config/common/packages-headless.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    curl
    file
    git
    lsof
    psmisc
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
}
