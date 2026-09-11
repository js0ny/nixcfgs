{ lib, ... }:
{
  options.js0ny.tailscale = {
    enable = lib.mkEnableOption "Enable Tailscale VPN client and service daemon.";
    ipv4 = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "100.x.y.z";
      description = "The assigned Tailscale IPv4 address for this specific node.";
    };
    ipv6 = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "fd7a:115c:a1e0:ab12:4843:cd96:6253:abcd";
      description = "The assigned Tailscale IPv6 address for this specific node.";
    };
    magicDNS = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "host.tailexample.ts.net";
      description = "The MagicDNS hostname for this specific node.";
    };
    authKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
    };
    exitNode = lib.mkEnableOption "Use as exit node";
  };
}
