{
  flake.nixosModules.strata =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.strata;
      package = pkgs.localPkgs.strata;
      epSelf = config.nixdefs.endpoints.strata;
      user = "strata";
      stateDir = "/var/lib/strata";
      # $STRATA_ROOT/data is a read-only symlink into the store (expert profiles,
      # draft vocabs); the model files need a name of their own inside the root.
      dataDir = "${stateDir}/Strata-data";
      modelTag = lib.toLower "${lib.optionalString (cfg.family != "qwen") "${cfg.family}-"}${cfg.model}";
      runConfig = "${stateDir}/strata-${modelTag}.json";
    in
    {
      options.services.strata = {
        family = lib.mkOption {
          type = lib.types.enum [
            "qwen"
            "swift"
            "coder"
            "unsloth"
          ];
          default = "qwen";
          description = "Model family downloaded and prepared by Strata.";
        };

        model = lib.mkOption {
          type = lib.types.enum [
            "Q2_0"
            "IQ2_XS"
            "IQ3_XXS"
            "IQ3_S"
            "IQ1_M"
            "UD-Q4_K_XL"
          ];
          default = "IQ2_XS";
          description = "Model quantisation; it must be available for the selected family.";
        };

        context = lib.mkOption {
          type = lib.types.ints.positive;
          default = 64 * 1024;
          description = "Maximum context length in tokens.";
        };

        kv = lib.mkOption {
          type = lib.types.enum [
            "int8"
            "q4_0"
            "k8v4"
          ];
          default = "int8";
          description = "KV cache precision for contexts longer than 8192 tokens.";
        };

        draftVocab = lib.mkOption {
          type = lib.types.enum [
            "cjk"
            "en"
            "cyrillic"
          ];
          default = "cjk";
          description = "Token vocabulary used by the speculative decoding draft layer.";
        };

        gpu = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 0;
          description = "NVIDIA GPU index as reported by nvidia-smi.";
        };
      };

      config = {
        nixdefs.endpoints.strata.port = lib.mkDefault 8080;

        users.users.${user} = {
          isSystemUser = true;
          group = user;
          home = stateDir;
          createHome = false;
          description = "Strata model server service user";
        };
        users.groups.${user} = { };

        systemd.tmpfiles.rules = [
          "d ${stateDir} 0700 ${user} ${user} -"
        ];

        js0ny.persist.stores.state.directories = [
          {
            directory = stateDir;
            inherit user;
            group = user;
            mode = "0700";
          }
        ];

        systemd.services.strata-prepare = {
          description = "Strata model preparation (explicit, resumable)";
          after = [ "network.target" ];
          path = [ config.hardware.nvidia.package ];
          serviceConfig = {
            Type = "oneshot";
            User = user;
            Group = user;
            SupplementaryGroups = [
              "video"
              "render"
            ];
            WorkingDirectory = stateDir;
            Environment = [ "STRATA_ROOT=${stateDir}" ];
            ExecStart = lib.escapeShellArgs [
              (lib.getExe' package "strata-setup")
              "--yes"
              "--setup"
              "--family"
              cfg.family
              "--model"
              cfg.model
              "--context"
              (toString cfg.context)
              "--vision"
              "no"
              "--kv"
              cfg.kv
              "--draft-vocab"
              cfg.draftVocab
              "--backend"
              "cuda"
              "--gpu"
              (toString cfg.gpu)
              "--host"
              epSelf.bindAddress
              "--port"
              (toString epSelf.port)
              "--no-start"
              "--data-dir"
              dataDir
            ];
            # A full model download takes hours.
            TimeoutStartSec = "infinity";
            ProtectSystem = "strict";
            ReadWritePaths = [ stateDir ];
            ProtectHome = true;
            PrivateTmp = true;
            NoNewPrivileges = true;
            LockPersonality = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            RemoveIPC = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
              "AF_NETLINK"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            AmbientCapabilities = "";
            CapabilityBoundingSet = "";
          };
        };

        systemd.services.strata = {
          description = "Strata model server";
          after = [ "network.target" ];
          unitConfig.ConditionPathExists = runConfig;
          serviceConfig = {
            Type = "simple";
            User = user;
            Group = user;
            WorkingDirectory = stateDir;
            Environment = [
              "STRATA_ROOT=${stateDir}"
              # The server itself needs NVML (libnvidia-ml.so.1); the engine child
              # gets the config's lib_dirs from serve/server.py.
              "LD_LIBRARY_PATH=/run/opengl-driver/lib"
            ];
            SupplementaryGroups = [
              "video"
              "render"
            ];
            ExecStart = lib.escapeShellArgs [
              (lib.getExe' package "strata-server")
              "--engine"
              "strata"
              "--config"
              runConfig
              "--host"
              epSelf.bindAddress
              "--port"
              (toString epSelf.port)
            ];
            # The engine pins host memory for its resident experts.
            LimitMEMLOCK = "infinity";
            LimitNOFILE = 65536;
            # Give the engine time to free its VRAM on SIGTERM.
            TimeoutStopSec = "120s";
            ProtectSystem = "strict";
            ReadWritePaths = [ stateDir ];
            ProtectHome = true;
            PrivateTmp = true;
            NoNewPrivileges = true;
            LockPersonality = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            RemoveIPC = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
              "AF_NETLINK"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            AmbientCapabilities = "";
            CapabilityBoundingSet = "";
          };
        };
      };
    };
}
