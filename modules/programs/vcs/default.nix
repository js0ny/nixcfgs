{
  flake.homeModules.vcs-extra =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.delta = {
        enable = true;
        enableGitIntegration = true;
        enableJujutsuIntegration = true;
      };
      programs.lazygit = {
        enable = true;
        settings = {
          git.pagers =
            if config.programs.delta.enable then [ { pager = "delta --dark --paging=never"; } ] else [ ];
        };
      };

      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = config.nixdots.user.name;
            email = config.nixdots.user.email;
          };
        };
      };
      programs.gh = {
        enable = true;
        hosts."github.com" = {
          user = lib.mkDefault config.home.username;
        };
        settings = {
          version = 1;
          git_protocol = "ssh";

          prompt = "enabled";

          aliases = {
            co = "pr checkout";
            pv = "pr view";
            cl = "repo clone";
          };
          telemetry = "disabled";
        };
      };
      home.packages = [ pkgs.tea ];
    };
}
