{ config, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = config.nixdots.user.name;
        email = config.nixdots.user.email;
      };
      alias = {
        cl = "clone";
        clnh = "clone --depth 1"; # Clone with no history
        cma = "commit -am"; # Add and commit
        logs = "log --oneline --graph --decorate --all"; # Show logs
        last = "log -1 HEAD"; # Show last commit
        undo = "reset --hard HEAD"; # Undo the last commit
      };
      core = {
        editor = if config.programs.neovim.enable then "nvim" else "vim";
        # Done by programs.delta.enableGitIntegration = true;
        # pager =
        #   if config.programs.delta.enable
        #   then "delta"
        #   else "diff";
        autocrlf = false;
        safecrlf = false;
        quotePath = false; # zh-CN: 解决中文路径问题
        eol = "lf";
      };
      init = {
        defaultBranch = "master";
      };
      url = {
        "git@codeberg.org:" = {
          insteadOf = "https://codeberg.org";
        };
      };
    };
    lfs.enable = true;
    ignores = [
      ".Trash-1000"
      ".Trash-1000/"
    ];
  };
}
