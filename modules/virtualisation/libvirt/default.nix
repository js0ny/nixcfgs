{
  flake.nixosModules.libvirt =
    {
      pkgs,
      config,
      ...
    }:
    let
      username = config.nixdots.user.name;
    in
    {
      environment.systemPackages = with pkgs; [
        # libvirt & qemu related
        dnsmasq
        virtiofsd
        virt-top
        qemu-utils

        # misc
        samba4Full
        sshfs
        spice-gtk
        virt-viewer
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
      nixdots.persist.nosnap.system = {
        directories = [
          "/var/lib/libvirt"
        ];
      };
    };
  flake.homeModules.libvirt = _: {
    xdg.configFile."libvirt/libvirt.conf".text = /* ini */ ''uri_default = "qemu:///system"'';

    dconf.settings = {
      "org/virt-manager/virt-manager" = {
        xmleditor-enabled = true;
      };
      "org/virt-manager/virt-manager/console" = {
        "grab-keys" = "65513,65507";
      };
    };
  };
}
