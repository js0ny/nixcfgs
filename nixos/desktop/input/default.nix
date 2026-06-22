{ ... }:
{
  imports = [
    ./keyd.nix
    ./xremap.nix
  ];
  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
      naturalScrolling = false;
    };
    touchpad = {
      disableWhileTyping = true;
      naturalScrolling = true;
    };
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
}
