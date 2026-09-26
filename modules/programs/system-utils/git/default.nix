{
  flake.nixosModules.git = { pkgs, ... }: {
    programs.git = {
      enable = true;
      package = pkgs.gitMinimal;
      lfs.enable = true;
      config = {
        core.editor = "nvim";
      };
    };
  };
  flake.homeModules.git =
    { pkgs, config, ... }:
    {
      programs.git = {
        enable = true;
        package = pkgs.gitMinimal;
        settings = {
          user = {
            name = config.js0ny.user.name;
            email = config.js0ny.user.email;
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
          gpg.format = "ssh";
          user.signingKey = "~/.ssh/id_ed25519_git_signing.pub";
          commit.gpgSign = true;
          tag.gpgSign = true;
        };
        lfs.enable = true;
        ignores = [
          ".Trash-1000"
          ".Trash-1000/"
          ".DS_Store"
          ".direnv"
          ".direnv/"
        ];
      };
    };
}
