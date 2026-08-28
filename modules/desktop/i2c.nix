{ config, pkgs, ... }:
{
  hardware.i2c.enable = true;
  js0ny.user.groups = [ config.hardware.i2c.group ];
  environment.systemPackages = with pkgs; [ i2c-tools ];
}
