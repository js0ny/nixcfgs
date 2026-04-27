{ pkgs, inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];
  programs.nixcord = {
    enable = true;

    # Clients
    discord = {
      enable = true;
      package =
        if pkgs.stdenv.isLinux then
          pkgs.nixpaks.discord
        else
          inputs.nixcord.packages.${pkgs.stdenv.hostPlatform.system}.discord;
      autoscroll.enable = true;
      vencord.enable = true;
    };

    # Plugins
    config = {
      plugins = {
        alwaysAnimate.enable = true;
        alwaysTrust.enable = true;
        ClearURLs.enable = true;
        copyFileContents.enable = true;
        CopyUserURLs.enable = true;
        disableCallIdle.enable = true;
        favoriteEmojiFirst.enable = true;
        forceOwnerCrown.enable = true;
        friendsSince.enable = true;
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
  nixdots.persist.home = {
    directories = [
      ".config/discord"
      ".config/Vencord"
      ".local/share/discord"
      ".cache/discord"
    ];
  };
  # nixdots.darwin.homebrew.casks = [ "discord" ];
}
