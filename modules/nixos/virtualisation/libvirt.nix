{
  pkgs,
  lib,
  config,
  ...
}:
let
  username = config.nixdots.user.name;
  cfg = config.nixdots.machine.virtualisation.libvirt;
in
lib.mkIf cfg.enable {
  environment.systemPackages = with pkgs; [
    dnsmasq
    virtiofsd
  ];
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
    onShutdown = "shutdown";
    onBoot = "ignore";
  };
  users.users."${username}" = {
    extraGroups = [ "libvirtd" ];
  };
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  virtualisation.spiceUSBRedirection.enable = true;
}
