{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.js0ny.persist;
  user = config.js0ny.user.name;
  homeStores = config.home-manager.users.${user}.js0ny.persist.stores or { };
  util-linux = config.boot.initrd.systemd.package.util-linux;
  coreutils = pkgs.coreutils;

  emptyHomeStore = {
    directories = [ ];
    files = [ ];
    commonMountOptions = [ ];
  };

  mkStore =
    name: systemStore:
    let
      homeStore = homeStores.${name} or emptyHomeStore;
      systemUser = systemStore.users.${user} or { };
      hasHomeState = homeStore.directories != [ ] || homeStore.files != [ ];
    in
    systemStore
    // {
      directories = lib.unique systemStore.directories;
      files = lib.unique systemStore.files;
      commonMountOptions = lib.unique (systemStore.commonMountOptions ++ [ "x-gvfs-hide" ]);
      users =
        systemStore.users
        // lib.optionalAttrs hasHomeState {
          ${user} = systemUser // {
            directories = lib.unique ((systemUser.directories or [ ]) ++ homeStore.directories);
            files = lib.unique ((systemUser.files or [ ]) ++ homeStore.files);
            commonMountOptions = lib.unique (
              (systemUser.commonMountOptions or [ ]) ++ homeStore.commonMountOptions ++ [ "x-gvfs-trash" ]
            );
          };
        };
    };

  storagePaths = lib.mapAttrsToList (_: store: toString store.persistentStoragePath) cfg.stores;
  unknownHomeStores = lib.subtractLists (lib.attrNames cfg.stores) (lib.attrNames homeStores);
in
{
  imports = [ inputs.preservation.nixosModules.preservation ];

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = unknownHomeStores == [ ];
        message = "Home Manager references undefined persistence stores: ${lib.concatStringsSep ", " unknownHomeStores}";
      }
      {
        assertion = storagePaths == lib.unique storagePaths;
        message = "Each persistence store must use a unique persistentStoragePath.";
      }
    ];

    preservation = {
      enable = true;
      preserveAt = lib.mapAttrs mkStore cfg.stores;
    };

    users.mutableUsers = lib.mkForce false;
    fileSystems = lib.genAttrs storagePaths (_: {
      neededForBoot = true;
    });

    environment.systemPackages = [
      pkgs.js0ny.oroot
      pkgs.localPkgs.impermanence-clean-old-roots
    ];
    programs.fish.interactiveShellInit = /* fish */ ''
      oroot completion fish | source
    '';
    programs.zsh.interactiveShellInit = /* zsh */ ''
      source <(oroot completion zsh)
    '';

    boot.initrd = {
      supportedFilesystems = [ "btrfs" ];
      systemd = {
        storePaths = with pkgs; [
          btrfs-progs
          coreutils
          findutils
          util-linux
        ];
        services.ephemeral-root-rollback = {
          description = "Rollback Btrfs root subvolume";
          wantedBy = [ "initrd.target" ];
          after = [
            "initrd-root-device.target"
            "systemd-udev-settle.service"
          ];
          wants = [ "systemd-udev-settle.service" ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          path = with pkgs; [
            btrfs-progs
            coreutils
            findutils
            util-linux
          ];
          script =
            let
              mkdir = lib.getExe' coreutils "mkdir";
              mv = lib.getExe' coreutils "mv";
              date = lib.getExe' coreutils "date";
              mount = lib.getExe' util-linux "mount";
              umount = lib.getExe' util-linux "umount";
              btrfs = lib.getExe pkgs.btrfs-progs;
              find = lib.getExe pkgs.findutils;
            in
            /* bash */ ''
              ${mkdir} -p /btrfs_tmp
              ${mount} /dev/disk/by-partlabel/disk-main-root /btrfs_tmp

              if [ -e /btrfs_tmp/root ]; then
                  ${mkdir} -p /btrfs_tmp/old_roots
                  timestamp=$(${date} +%Y-%m-%d_%H-%M-%S)
                  ${mv} /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
              fi

              delete_subvolume_recursively() {
                  IFS=$'\n'
                  for i in $(${btrfs} subvolume list -o "$1" | cut -f 9- -d ' '); do
                      delete_subvolume_recursively "/btrfs_tmp/$i"
                  done
                  ${btrfs} subvolume delete "$1"
              }

              for i in $(${find} /btrfs_tmp/old_roots/ -mindepth 1 -maxdepth 1 -mtime +30); do
                  delete_subvolume_recursively "$i"
              done

              ${btrfs} subvolume create /btrfs_tmp/root
              ${umount} /btrfs_tmp
            '';
        };
      };
    };
  };
}
