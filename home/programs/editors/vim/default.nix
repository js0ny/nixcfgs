{ config, ... }:
{
  xdg.configFile."vim/vimrc".source = ./vimrc;
  systemd.user.tmpfiles.rules = [
    "d ${config.xdg.stateHome}/vim"
  ];
}
