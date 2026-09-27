{
  flake.nixosModules.siyuan =
    { pkgs, lib, ... }:
    let
      stateDir = "/var/lib/siyuan";
      port = 6806;
      portStr = toString port;
    in
    {

      systemd.services.siyuan = {
        description = "SiYuan headless server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment = {
          HOME = stateDir;
          SIYUAN_WORKSPACE_PATH = "/var/lib/siyuan/workspace";
          SIYUAN_LANG = "zh-CN";
          SIYUAN_ACCESS_AUTH_CODE_BYPASS = "true";
        };

        serviceConfig = {
          ExecStart = lib.escapeShellArgs [
            (lib.getExe' pkgs.siyuan.passthru.kernel "kernel")
            "serve"
            "--wd=${pkgs.siyuan}/share/siyuan/resources"
            "--port=${portStr}"
          ];

          StateDirectory = "siyuan";
          Restart = "on-failure";
          RestartSec = 5;
          EnvironmentFile = "";

          User = "siyuan";
          Group = "siyuan";
        };
      };

      users.users.siyuan = {
        isSystemUser = true;
        group = "siyuan";
        home = stateDir;
      };
      users.groups.siyuan = { };

      js0ny.persist.stores.state.directories = [ "/var/lib/siyuan" ];
    };
}
