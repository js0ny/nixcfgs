{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.js0ny.hardware.gpu.driver;
  laptop = config.js0ny.hardware.laptop.enable;
  busIds = config.js0ny.hardware.gpu.busIds;
  hasAnyBusId = busIds.nvidia != null || busIds.intel != null || busIds.amdgpu != null;
  hasOffloadBusIds = busIds.nvidia != null && (busIds.intel != null || busIds.amdgpu != null);
in
lib.mkIf (cfg == "nvidia") (
  lib.mkMerge [
    {
      nixpkgs.config = {
        allowUnfreePredicate = pkgs._cuda.lib.allowUnfreeCudaPredicate;
        # cudaSupport = true;
      };
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement = {
          enable = lib.mkIf (!laptop || !hasOffloadBusIds) true;
          finegrained = lib.mkIf (laptop && hasOffloadBusIds) true;
        };
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.production;
      };
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      environment.systemPackages = [
        pkgs.nvtopPackages.nvidia
        config.hardware.nvidia-container-toolkit.package
      ];
      hardware.nvidia-container-toolkit.enable = true;
    }

    (lib.mkIf laptop {
      assertions = lib.optional hasAnyBusId {
        assertion = hasOffloadBusIds;
        message = "js0ny.hardware.gpu.busIds must set nvidia and one of intel or amdgpu for NVIDIA PRIME offload.";
      };

      hardware.nvidia.prime = lib.mkIf hasOffloadBusIds (
        {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          nvidiaBusId = busIds.nvidia;
        }
        // lib.optionalAttrs (busIds.intel != null) {
          intelBusId = busIds.intel;
        }
        // lib.optionalAttrs (busIds.amdgpu != null) {
          amdgpuBusId = busIds.amdgpu;
        }
      );
    })
  ]
)
