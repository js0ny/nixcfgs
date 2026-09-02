{
  nixos = {
    bauhaus.tailscaleIp = "100.65.81.67";
    belvedere = {
      tailscaleIp = "100.98.217.124";
      deploy = { };
    };
    crystal = {
      tailscaleIp = "100.101.8.90";
      deploy.interactiveSudo = true;
    };
    polder = {
      tailscaleIp = "100.92.207.11";
      deploy = { };
    };
    zwinger = {
      tailscaleIp = "100.97.155.65";
      deploy = { };
    };
    revival = {
      tailscaleIp = "192.168.10.154";
      deploy = { };
    };
  };

  darwin.zen = { };
}
