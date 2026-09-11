{ lib, ... }:
{
  options.nixdots = {
    services = {
      tailscale = {
        enable = lib.mkEnableOption "Enable Tailscale VPN client and service daemon.";
        ip = lib.mkOption {
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
          type = lib.types.str;
          default = null;
        };
        exitNode = lib.mkEnableOption "Use as exit node";
      };
      ollama = {
        enable = lib.mkEnableOption "Whether to enable ollama server for local large language models.";
        models = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "bge-m3" ];
          description = ''
            Download these models using ollama pull as soon as ollama.service has started.
          '';
        };
      };
    };
  };
}
