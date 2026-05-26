# NOTE: Human Intervention required on first setup
/*
  sudo garage layout status
  sudo garage layout assign <ID> -z dc1 -c 50G
  sudo garage layout show
  sudo garage layout apply --version 1
*/
{
  pkgs,
  lib,
  config,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  persist = config.nixdots.persist;
  # garage requires dirs to sit in the same fs
  basedir = if persist.enable then "${persist.path}/var/lib/garage" else "/var/lib/garage";
  dirs = {
    meta = "${basedir}/meta";
    data = "${basedir}/data";
    snapshots = "${basedir}/snapshots";
  };
  serviceUser = config.systemd.services.garage.serviceConfig.User;
  serviceGroup = config.systemd.services.garage.serviceConfig.Group;
  pkg = pkgs.garage_2;
  inherit (lib) mkDefault mkForce;
in
{
  sops.secrets = {
    # openssl rand -hex 32
    garage_rpc_secret = {
      owner = serviceUser;
    };
  };
  services.garage = {
    package = pkg;
    # https://garagehq.deuxfleurs.fr/documentation/reference-manual/configuration/
    settings = {
      rpc_bind_addr = "[::]:${toString ep.garage-rpc.port}";
      rpc_secret_file = config.sops.secrets.garage_rpc_secret.path;
      s3_api = {
        s3_region = "garage";
        api_bind_addr = "[::]:${toString ep.garage-s3.port}";
      };
      s3_web = {
        bind_addr = "[::]:${toString ep.garage-web.port}";
        root_domain = mkDefault ".web.garage.localhost";
      };
      metadata_dir = dirs.meta;
      data_dir = dirs.data;
      metadata_snapshots_dir = dirs.snapshots;
      replication_factor = mkDefault 1;
      db_engine = mkDefault "lmdb";
    };
    extraEnvironment = {
      GARAGE_LOG_TO_JOURNALD = "true";
    };
  };
  users.users.garage = {
    isSystemUser = true;
    group = "garage";
    description = "Garage S3 storage user";
  };
  users.groups.garage = { };

  systemd.services.garage.serviceConfig = {
    DynamicUser = mkForce false;
    User = "garage";
    Group = "garage";
    StateDirectory = if persist.enable then basedir else "garage";
    ReadWritePaths = [ basedir ];
  };

  systemd.tmpfiles.rules = [
    "d ${basedir} 0755 ${serviceUser} ${serviceGroup} -"
    "d ${dirs.meta} 0755 ${serviceUser} ${serviceGroup} -"
    "d ${dirs.data} 0755 ${serviceUser} ${serviceGroup} -"
    "d ${dirs.snapshots} 0755 ${serviceUser} ${serviceGroup} -"
  ];

  environment.systemPackages = [ pkg ];
}
