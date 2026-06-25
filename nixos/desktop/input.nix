{ config, ... }:
let

  username = config.nixdots.user.name;
in
{
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

  services.xserver.xkb.layout = "us";

  # treat the virtual keyboard as internal,
  # since most "Disable Trackpad While Typing"
  # won't work if you are using a virtual keyboard.
  # https://github.com/xremap/xremap/discussions/656
  environment.etc."libinput/local-overrides.quirks".text = /* ini */ ''
    [xremap]
    MatchName=xremap
    MatchUdevType=keyboard
    AttrKeyboardIntegration=internal
  '';

  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  services.udev.extraRules = /* udev */ ''
    KERNEL=="uinput", GROUP="input", TAG+="uaccess"
  '';
  users.users."${username}".extraGroups = [
    "input"
    "uinput"
  ];
}
