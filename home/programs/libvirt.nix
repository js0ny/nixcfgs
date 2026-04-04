{
  pkgs,
  lib,
  config,
  ...
}: let
  # devs = [
  #   "0bda:9210" # Realtek Semiconductor Corp. RTL9210 M.2 NVME Adapter
  # ];
  cfg = config.nixdots.machine.virtualisation.libvirt;
in
  lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      localPkgs.fzfScripts.virt-manager-view-fzf
      remmina
    ];

    xdg.configFile."libvirt/libvirt.conf" = {
      text = ''uri_default = "qemu:///system"'';
      enable = true;
    };

    dconf.settings = {
      "org/virt-manager/virt-manager" = {
        xmleditor-enabled = true;
      };
      "org/virt-manager/virt-manager/console" = {
        "grab-keys" = "65513,65507";
      };
    };
  }
