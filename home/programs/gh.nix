{ lib, config, ... }:
{
  programs.gh = {
    enable = true;
    hosts."github.com" = {
      user = lib.mkDefault config.home.username;
    };
    settings = {
      git_protocol = "ssh";

      prompt = "enabled";

      aliases = {
        co = "pr checkout";
        pv = "pr view";
        cl = "repo clone";
      };
    };
  };
}
