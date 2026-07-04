{
  flake.nixosModules.desktop = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # keep-sorted start
      ddcutil # requires i2c enabled
      efibootmgr
      f2fs-tools
      gnome-firmware
      libnotify
      libva-utils
      lm_sensors
      ltrace
      mesa-demos
      nvme-cli
      openvpn
      pciutils
      sbctl
      smartmontools
      strace
      usbutils
      v4l-utils
      vulkan-tools
      wayland-utils
      wf-recorder
      wl-clipboard
      # keep-sorted end

      mat2
      metadata-cleaner

      loupe # SUPER FAST 有催人跑的感觉
      mpv
      sioyek

      zenity
    ];
    programs.gnome-disks.enable = true;
    programs.gpu-screen-recorder.enable = true;
    environment.sessionVariables = {
      NIXOS_OZONE_WL = 1;
    };
  };
  flake.homeModules.desktop = { pkgs, lib, ... }: {
    home.packages =
      with pkgs;
      [
        ripgrep-all
        proton-pass-cli
        localPkgs.edit-clipboard
        localsend
        pandoc
        dos2unix
        gron
        httpie
        jless
        jq
        yq-go
      ]
      ++ ((lib.optionals pkgs.stdenv.isLinux) [
        # keep-sorted start
        bluetui
        dex
        ffmpeg
        imagemagick
        kdePackages.ark
        # Image Viewer
        nixpaks.ticktick
        # Theming
        papirus-icon-theme
        qbittorrent
        qpwgraph
        remmina
        ripdrag
        showmethekey
        signal-desktop
        siyuan
        # keep-sorted end
      ])
      ++ ((lib.optionals pkgs.stdenv.isDarwin) [
        # keep-sorted start
        betterdisplay
        macism # swift-native im-select alternative
        orbstack
        # keep-sorted end
      ]);

    nixdots.darwin.homebrew = {
      taps = [
        # "daipeihust/tap" # im-select
      ];
      formulae = [
        # "daipeihust/tap/im-select"
        "folderify"
      ];
      casks = [
        "ticktick"
        "proton-drive"
      ];
    };

    home.sessionVariables = lib.optionalAttrs (pkgs.stdenv.isLinux) {
      PROTON_PASS_LINUX_KEYRING = "dbus";
    };

    nixdots.persist.nosnap.home.directories = [ ".config/ticktick" ];
  };
}
