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
        # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
        settings = {
          os.copyToClipboardCmd = "printf '%s' {{text}} | ${lib.getExe pkgs.localPkgs.clipboard-copy}";
          # Lazygit also switches paste to a custom command when copy is overridden.
          os.readFromClipboardCmd = lib.escapeShellArgs [
            (lib.getExe pkgs.zsh)
            "-f"
            "-c"
            "source ${../shell/zsh/zsh_clipboard_paste.zsh}; zsh_clipboard_paste"
          ];
          git.diffRenderers =
            if config.programs.delta.enable then [ { command = "delta --dark --paging=never"; } ] else [ ];
        };
      };

      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = config.js0ny.user.name;
            email = config.js0ny.user.email;
          };
        };
      };

      programs.jjui = {
        enable = true;
      };

      programs.gh = {
        enable = true;
        hosts."github.com" = {
          user = lib.mkDefault config.home.username;
          git_protocol = "ssh";
          users.${config.home.username}.git_protocol = "ssh";
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
      home.packages = with pkgs; [
        localPkgs.clipboard-copy
        tea
        lazyjj
      ];
    };
}
