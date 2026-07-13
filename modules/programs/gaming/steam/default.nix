{
  flake.nixosModules.steam =
    {
      pkgs,
      lib,
      ...
    }:
    {
      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
        fontPackages = with pkgs; [
          # source-han-sans
          wqy_zenhei
        ];
      };

      programs.gamemode = {
        enable = true;
        enableRenice = true;
        settings = {
          custom = {
            start = "${lib.getExe pkgs.libnotify} -u low -a 'GameMode' 'GameMode Started'";
            end = "${lib.getExe pkgs.libnotify} -u low -a 'GameMode' 'GameMode Ended'";
          };
        };
      };
    };
  flake.homeModules.steam =
    {
      pkgs,
      lib,
      inputs,
      ...
    }:
    let
      vicinae-extensions = inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      home.sessionVariables = lib.optionalAttrs (pkgs.stdenv.isLinux) {
        SDL_JOYSTICK_HIDAPI = "0";
      };
      home.packages = with pkgs; [
        # Steam Achievement Manager
        samira
        steamcmd # from overlays
        # Steam Adwaita Theme
        adwsteamgtk
        # All-in-one Steam and Proton Tools
        steamtinkerlaunch
      ];
      nixdots.persist.nosnap.home = {
        directories = [
          ".local/share/Steam"
          ".steam"
        ];
      };
      # https://github.com/different-name/steam-config-nix/blob/master/options.md
      programs.steam.config = {
        enable = true;
        onSteamRunning = "close";
      };
      # Lost & Found
      xdg.desktopEntries = {
        samira = {
          name = "Samira";
          icon = "samira";
          comment = "Steam achievement manager for Linux";
          exec = "samira";
          terminal = false;
          categories = [
            "Game"
          ];
          settings = {
            StartupWMClass = "samira";
          };
        };
      };
      programs.vicinae.extensions = with vicinae-extensions; [ protondb-search ];
    };

  flake.nixosModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.nixosModules.steam ];
  };
  flake.homeModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.homeModules.steam ];
  };
}
