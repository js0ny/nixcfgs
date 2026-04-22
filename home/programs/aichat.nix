{ ... }:
{
  /*
    Secret installation: (if you do not want to set environment globally)
    sops.templates."aichat.env" = {
      content =  ''
        SPECIFICCLIENT_API_KEY=${config.sops.placeholder.specific_client_api}
      '';
      path = "${config.xdg.configHome}/aichat/.env";
    };
  */
  nixdots.programs.shellAliases = {
    aic = "aichat -s";
  };
  programs.aichat = {
    enable = true;
    settings = {
      save_session = false;
      wrap = "auto";
      keybindings = "emacs";
    };
  };
}
