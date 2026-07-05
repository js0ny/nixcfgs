{ pkgs, secrets, ... }:
{
  sops.secrets = {
    llm_key_pidev = {
      sopsFile = secrets + /llm-integrations.yaml;
    };
  };
  home.packages = [ pkgs.llm-agents.omp ];

  nixdots.persist.home.directories = [
    ".config/pi"
  ];
}
