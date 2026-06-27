{ ... }:
{
  services.code-server = {
    enable = true;
    disableTelemetry = true;
    host = "0.0.0.0";
  };
}
