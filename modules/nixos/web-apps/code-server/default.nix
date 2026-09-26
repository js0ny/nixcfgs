{
  flake.nixosModules.code-server = _: {
    services.code-server = {
      enable = true;
      disableTelemetry = true;
      disableGettingStartedOverride = true;
      disableUpdateCheck = true;
      disableWorkspaceTrust = true;
      host = "0.0.0.0";
      user = "js0ny";
      group = "users";
    };
  };
}
