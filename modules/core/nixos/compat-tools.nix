{
  pkgs,
  lib,
  config,
  ...
}:
{
  # cannot emulate self.
  boot.binfmt.emulatedSystems = lib.filter (platform: platform != pkgs.stdenv.hostPlatform.system) [
    "x86_64-linux"
    "aarch64-linux"
  ];
  programs.nix-ld = {
    enable = true;
    libraries =
      with pkgs;
      [
        stdenv.cc.cc
        dbus
        zstd
      ]
      ++ (lib.optionals (config.hardware.graphics.enable) [
        glib
        libxcb
        libGL
        libsecret
      ]);
  };
}
