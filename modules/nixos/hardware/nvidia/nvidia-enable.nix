{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nixdots.linux.gpu;
  laptop = config.nixdots.laptop.enable;
  busIds = config.nixdots.linux.gpuBusIds;
  hasAnyBusId = busIds.nvidia != null || busIds.intel != null || busIds.amdgpu != null;
  hasOffloadBusIds = busIds.nvidia != null && (busIds.intel != null || busIds.amdgpu != null);
in
lib.mkIf (cfg == "nvidia") (
  lib.mkMerge [
    {
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.production;
      };
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      services.ollama.package = pkgs.ollama-cuda;
    }

    (lib.mkIf laptop {
      assertions = lib.optional hasAnyBusId {
        assertion = hasOffloadBusIds;
        message = "nixdots.linux.gpuBusIds must set nvidia and one of intel or amdgpu for NVIDIA PRIME offload.";
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
