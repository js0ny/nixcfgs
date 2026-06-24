{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.gocryptfs;
  home = config.home.homeDirectory;
  user = config.home.username;
  encryptedPath = "${home}/${cfg.encryptedDir}";
  mountPath = "${home}/${cfg.mountPoint}";
  gocryptfsArgs = [
    "-fg"
    "-passfile"
    cfg.autoMount.passwordFile
    encryptedPath
    mountPath
  ];
  mountScript = pkgs.writeShellApplication {
    name = "gocryptfs-mount";
    runtimeInputs = with pkgs; [ coreutils ];
    text = /* bash */ ''
      mkdir -p ${lib.escapeShellArg mountPath}
      exec ${lib.getExe' pkgs.gocryptfs "gocryptfs"} ${lib.escapeShellArgs gocryptfsArgs}
    '';
  };
in
{
  # [Human Intervention] Run `gocryptfs -init ${encryptedPath}` once before using this module.
  options.programs.gocryptfs = {
    enable = lib.mkEnableOption "gocryptfs encrypted filesystem";

    encryptedDir = lib.mkOption {
      type = lib.types.str;
      example = "Vault.enc";
      description = "Encrypted directory relative to the home directory.";
    };

    mountPoint = lib.mkOption {
      type = lib.types.str;
      example = "Vault";
      description = "Mount point relative to the home directory.";
    };

    autoMount = {
      enable = lib.mkEnableOption "automatic gocryptfs mount";

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "${home}/.local/share/gocryptfs/passfile";
        description = "Path to a gocryptfs passfile used for automatic mounting.";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = cfg.autoMount.enable -> cfg.autoMount.passwordFile != null;
            message = "programs.gocryptfs.autoMount.passwordFile must be set when autoMount is enabled.";
          }
        ];

        home.packages = [ pkgs.gocryptfs ];

        nixdots.persist.home.directories = [ cfg.encryptedDir ];

        systemd.user.tmpfiles.rules = [
          "d ${mountPath} 0700 ${user} users -"
        ];
      }

      (lib.mkIf (cfg.autoMount.enable && pkgs.stdenv.isLinux) {
        systemd.user.services.gocryptfs = {
          Unit = {
            Description = "gocryptfs encrypted filesystem";
            After = [ "graphical-session-pre.target" ];
          };
          Service = {
            ExecStart = lib.getExe mountScript;
            Restart = "on-failure";
          };
          Install.WantedBy = [ "default.target" ];
        };
      })

      (lib.mkIf (cfg.autoMount.enable && pkgs.stdenv.isDarwin) {
        launchd.agents.gocryptfs = {
          enable = true;
          config = {
            ProgramArguments = [ (lib.getExe mountScript) ];
            KeepAlive = true;
            RunAtLoad = true;
          };
        };
      })
    ]
  );
}
