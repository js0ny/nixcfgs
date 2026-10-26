{ inputs, lib, ... }:
{
  imports = [ inputs.self.homeModules.linux ];

  dconf.enable = lib.mkDefault false;
}
