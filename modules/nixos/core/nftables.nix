{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.nixdots.networking.nftables.enable;
in
  lib.mkIf cfg {
    networking.nftables = {
      enable = true;
    };
    networking.firewall.backend = "nftables";

    environment.systemPackages = with pkgs; [
      iptables-nftables-compat
    ];
  }
