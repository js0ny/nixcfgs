{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.enable;
in
lib.mkIf cfg {
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  nixdots.persist.system = {
    directories = [
      "/var/lib/bluetooth"
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
  };

}
