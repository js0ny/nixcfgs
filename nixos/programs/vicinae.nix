{ lib, config, ... }:
let
  username = config.nixdots.user.name;
  features = config.nixdots.features;
  cfg = features.tools.vicinae;
in
lib.mkIf cfg.enable {
  boot.kernelModules = [ "uinput" ];
  users.users."${username}".extraGroups = [
    "input"
    "uinput"
  ];
}
