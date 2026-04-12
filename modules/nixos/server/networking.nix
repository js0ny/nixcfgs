{ ... }:
{
  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
      "2606:4700:4700::1111"
      "2001:4860:4860::8888"
    ];
  };
  nixdots.persist.system = {
    directories = [
      "/var/lib/systemd/network"
      "/var/lib/systemd/rfkill"
    ];
  };
}
