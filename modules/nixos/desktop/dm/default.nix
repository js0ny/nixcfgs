{ config, ... }:
{
  imports = [
    ./cosmic-greeter.nix
    ./gdm.nix
    ./ly.nix
    ./sddm.nix
  ];

  services.displayManager.defaultSession = builtins.head config.nixdots.desktop.de;
}
