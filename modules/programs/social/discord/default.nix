{
  flake.homeModules.discord =
    { pkgs, inputs, ... }:
    {
      home.packages = with pkgs; [ concord-tui ];
      imports = [ inputs.nixcord.homeModules.nixcord ];
      programs.nixcord = {
        enable = true;

        # Clients
        discord = {
          enable = true;
          # package =
          #   if pkgs.stdenv.isLinux then
          #     pkgs.nixpaks.discord
          #   else
          #     inputs.nixcord.packages.${pkgs.stdenv.hostPlatform.system}.discord;
          vencord.enable = true;
          commandLineArgs = [
            "--enable-blink-features=MiddleClickAutoscroll"
          ];
        };

        # Plugins
        config = {
          plugins = {
            alwaysAnimate.enable = true;
            alwaysTrust.enable = true;
            clearUrls.enable = true;
            copyFileContents.enable = true;
            copyUserUrls.enable = true;
            disableCallIdle.enable = true;
            favoriteEmojiFirst.enable = true;
            forceOwnerCrown.enable = true;
            noDevtoolsWarning.enable = true;
            readAllNotificationsButton.enable = true;
            serverInfo.enable = true;
            showMeYourName = {
              enable = true;
              includedNames = "{friend, nick} [{display}] (@{user})";
            };
            silentMessageToggle.enable = true;
            silentTyping.enable = true;
            startupTimings.enable = true;
            validReply.enable = true;
            validUser.enable = true;
          };
        };
      };
      nixdots.persist.nosnap.home = {
        directories = [
          ".config/discord"
        ];
      };

    };
}
