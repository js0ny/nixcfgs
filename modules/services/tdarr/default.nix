{
  flake.nixosModules.tdarr =
    # NOTE: Wait for upstream fix
    { config, ... }:
    let
      ep = config.nixdefs.endpoints;
      url = ep.tdarr.domain;
      port = ep.tdarr.port;
      serverPort = ep.tdarr-server.port;
    in
    {
      services.tdarr = {
        enable = true;
        server = {
          serverPort = serverPort;
          webUIPort = port;
        };
        nodes = {
          local = {
            workers = {
              transcodeCPU = 2;
              healthcheckCPU = 1;
            };
          };
        };
      };
    };
}
