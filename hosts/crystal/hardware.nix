{ pkgs, config, ... }: {
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.ryzen-smu ];

  environment.systemPackages = [
    pkgs.ryzenadj
  ];
}
