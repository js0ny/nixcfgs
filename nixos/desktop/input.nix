# This file only contains logic that give previledges to xremap user
# See home-manager configs for detailed options
_: {
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
}
