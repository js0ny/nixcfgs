{
  flake.nixosModules.tmux = _: {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
    };
  };
  flake.homeModules.tmux =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        prefix = "C-a";
        shortcut = "a";
        keyMode = "vi";
        historyLimit = 10000;
        mouse = true;
        baseIndex = 1;
        resizeAmount = 5;
        terminal = "tmux-256color";
        tmuxp.enable = true;
        plugins = with pkgs.tmuxPlugins; [
          pain-control
          yank
          extrakto
          tmux-which-key
          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-strategy-nvim 'session'
              set -g @resurrect-capture-pane-contents 'on'
            '';
          }
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '15'
            '';
          }
        ];
        extraConfig = ''
          set-option -g default-terminal "tmux-256color"
          set-option -g allow-rename on
          set-option -g alternate-screen on
          set-option -g visual-activity on
          bind c new-window
          unbind '"'
          unbind %
          bind ` resize-pane -Z
        '';
      };
    };
}
