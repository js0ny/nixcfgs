{ config, ... }: {

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

}
