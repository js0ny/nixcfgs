{ config, lib, ... }:
let
  touchpad = config.nixdots.laptop.touchpad;
in
lib.mkIf config.nixdots.laptop.enable {
  programs.plasma = {
    input.touchpads = [
      {
        disableWhileTyping = true;
        enable = true;
        leftHanded = false;
        middleButtonEmulation = true;
        name = touchpad.name;
        productId = touchpad.productId;
        vendorId = touchpad.vendorId;
        naturalScroll = true;
        pointerSpeed = 0;
        tapToClick = true;
        accelerationProfile = "none";
        scrollSpeed = 0.15;
      }
    ];
  };
}
