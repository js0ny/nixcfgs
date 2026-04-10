{
  lib,
  config,
  ...
}:
{
  options.nixdots.machine.virtualisation = {
    enable = lib.mkEnableOption "Whether to enable virtualisation features (e.g., KVM, libvirt) on this machine. This is typically enabled for host machines that run virtual machines.";
    waydroid = lib.mkEnableOption "Whether to enable Waydroid for running Android apps. This is typically enabled on desktop machines that want to run Android applications.";
    libvirt = {
      enable = lib.mkEnableOption "Whether to enable libvirt for managing virtual machines. This is typically enabled on host machines that run virtual machines.";
      virt-manager = lib.mkOption {
        type = lib.types.bool;
        default = config.nixdots.machine.virtualisation.libvirt.enable;
        description = "Whether to install virt-manager for managing virtual machines.";
      };
      virt-viewer = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to install virt-viewer for viewing virtual machine consoles.";
      };
    };
    oci-container = {
      docker = lib.mkEnableOption "Whether to enable Docker for container management. This is typically enabled on host machines that run containers.";
      podman = lib.mkEnableOption "Whether to enable Podman for container management. This is typically enabled on host machines that run containers.";
    };
  };
}
