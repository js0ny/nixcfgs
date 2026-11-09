{ lib, config, ... }:
let
  port = config.nixdefs.endpoints.ssh.port;
in
{
  services.openssh = {
    enable = true;
    ports = [ port ];
    settings = {
      UseDns = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AcceptEnv = lib.mkForce [ "TERM_PROGRAM" ];
    };
  };
  networking.firewall.allowedTCPPorts = [ port ];
  /*
    # sshd

    ## Troubleshoot

    ### duplicated ports

    when duplicated ports is defined in `sshd_config`:

    ```bash
    $ sudo sshd -T | rg '^port '
    ```

    The service will fail to start, prompting: `Bind to port {PORT} on {ADDR} failed: Address already in use.`

    A temporary workaround is

    ```bash
    sudo systemctl stop sshd
    sudo systemd-run \
      --unit=sshd-emergency \
      --property=Restart=on-failure \
      --property=RestartSec=2 \
      /run/current-system/sw/bin/sshd \
      -D \
      -p ${PORT} \
      -o PidFile=/run/sshd-emergency.pid
    ```
  */
  assertions =
    let
      ports = config.services.openssh.ports;
    in
    [
      {
        assertion = ports == lib.unique ports;
        message = ''
          services.openssh.ports contains duplicate ports:
            ${lib.generators.toPretty { } ports}
        '';
      }
      {
        assertion = ports != [ ];
        message = ''
          OpenSSH service with no port configured.
        '';
      }
    ];
}
