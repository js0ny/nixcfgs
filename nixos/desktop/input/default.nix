{ ... }:
{
  imports = [
    ./keyd.nix
    ./xremap.nix
  ];
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
}
