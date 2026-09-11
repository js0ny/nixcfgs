{
  nixos = {
    bauhaus = {
      tailscale = {
        ipv4 = "100.65.81.67";
        ipv6 = "fd7a:115c:a1e0::f735:5144";
        magicDNS = "bauhaus.tailee8d62.ts.net";
      };
      deploy = { };
    };
    belvedere = {
      tailscale = {
        ipv4 = "100.98.217.124";
        ipv6 = "fd7a:115c:a1e0::7835:d97d";
        magicDNS = "belvedere.tailee8d62.ts.net";
        exitNode = true;
      };
      deploy = { };
    };
    crystal = {
      tailscale = {
        ipv4 = "100.101.8.90";
        ipv6 = "fd7a:115c:a1e0::ce35:85a";
        magicDNS = "crystal.tailee8d62.ts.net";
      };
      deploy.interactiveSudo = true;
    };
    # polder = {
    #   tailscale.ipv4 = "100.92.207.11";
    #   deploy = { };
    # };
    zwinger = {
      tailscale = {
        ipv4 = "100.97.155.65";
        ipv6 = "fd7a:115c:a1e0::b035:9b42";
        magicDNS = "zwinger.tailee8d62.ts.net";
      };
      deploy = { };
    };
    revival = {
      tailscale = {
        ipv4 = "100.105.48.55";
        ipv6 = "fd7a:115c:a1e0::7028:3038";
        magicDNS = "revival.tailee8d62.ts.net";
        exitNode = true;
      };
      deploy = { };
    };
  };

  darwin.zen = {
    tailscale = {
      ipv4 = "100.118.212.79";
      ipv6 = "fd7a:115c:a1e0::f835:d450";
      magicDNS = "zen.tailee8d62.ts.net";
    };
  };
}
