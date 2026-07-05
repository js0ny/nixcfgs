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

        # viewer
        spice-gtk
        virt-viewer
        localPkgs.fzfScripts.virt-manager-view-fzf
        remmina

        # misc. fs
        samba4Full
        sshfs
        guestfs-tools

        # misc
        quickemu
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
      # https://github.com/NixOS/nixpkgs/issues/501336#issuecomment-4092515359
      # /var/lib/libvirt/secrets/secrets-encryption-key will cause libvirt to fail to start.
      fileSystems = {
        "/var/lib/libvirt/secrets" = {
          device = "tmpfs";
          fsType = "tmpfs";
          options = [
            "size=1M"
            "mode=0700"
            "uid=0"
            "gid=0"
            "x-systemd.requires-mounts-for=/var/lib/libvirt"
          ];
        };
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
