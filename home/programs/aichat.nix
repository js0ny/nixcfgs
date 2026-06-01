{ config, secrets, ... }:
{
  sops.secrets = {
    llm_key_aichat = {
      sopsFile = secrets + /llm-integrations.yaml;
    };
  };
  sops.templates."aichat.env" = {
    content = /* bash */ ''
      LITELLM_API_KEY=${config.sops.placeholder.llm_key_aichat}
    '';
    path = "${config.xdg.configHome}/aichat/.env";
    mode = "0400";
  };
  misc.shellAliases = {
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
  systemd.user.tmpfiles.rules = [
    "d ${config.xdg.configHome}/aichat 0700 ${config.home.username} users -"
  ];
}
