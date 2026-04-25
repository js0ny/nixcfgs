{ ... }:
{
  services.awww = {
    enable = true;
  };
  systemd.user.services.awww.Install.WantedBy = [ "niri.service" ];
}
