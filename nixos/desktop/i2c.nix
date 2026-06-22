{ config, pkgs, ... }:
{
  hardware.i2c.enable = true;
  users.users.${config.nixdots.user.name}.extraGroups = [ config.hardware.i2c.group ];
  environment.systemPackages = with pkgs; [ i2c-tools ];
}
