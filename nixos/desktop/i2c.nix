{ config, pkgs, ... }:
{
  hardware.i2c.enable = true;
  users.users.${config.nixdots.user.name}.extraGroups = [ "i2c" ];
  environment.systemPackages = with pkgs; [ i2c-tools ];
}
