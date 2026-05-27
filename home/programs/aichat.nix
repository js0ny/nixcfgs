{ config, ... }:
{
  sops.templates."aichat.env" = {
    content = /* bash */ ''
      LITELLM_API_KEY=${config.sops.placeholder.llm_key_aichat}
    '';
    path = "${config.xdg.configHome}/aichat/.env";
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
}
