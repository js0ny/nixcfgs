{
  pkgs,
  lib,
  config,
  ...
}:
let
  user = config.nixdots.user.name;
in
lib.mkIf config.hardware.graphics.enable {
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  users.users.${user}.extraGroups = [ "wireshark" ];
}
