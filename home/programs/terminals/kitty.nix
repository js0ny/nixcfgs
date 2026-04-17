{
  config,
  pkgs,
  lib,
  ...
}:
let
  alt = if pkgs.stdenv.isDarwin then "cmd" else "alt";
  shell = config.nixdots.apps.interactiveShell.package;
in
{
  xdg.configFile."kitty/kitty.conf".force = true;
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    environment = {
      "TERM_PROGRAM" = "kitty";
      "COLORTERM" = "truecolor";
    };
    font = {
      size = 12;
      name = (builtins.head config.nixdots.style.fonts.editorMono).name;
    };
    settings = {
      # Font
      disable_ligatures = "never";
      # Cursor Trail
      cursor_trail = 1;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;
      # Tab Bar
      tab_bar_edge = "top";
      tab_bar_align = "left";
      tab_bar_style = "powerline";
      # Hide tab bar when there is only one tab
      tab_bar_min_tabs = 2;
      tab_title_template = "{f'{title[:30]}…' if title.rindex(title[-1]) + 1 > 30 else (title.center(6) if (title.rindex(title[-1]) + 1) % 2 == 0 else title.center(5))}";
      active_tab_font_style = "bold";
      macos_option_as_alt = true;
      macos_quit_when_last_window_closed = true;
      enabled_layouts = "splits";
      shell = lib.getExe shell;
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty.sock";
      confirm_os_window_close = 0;
    };
    keybindings = {
      "cmd+c" = "copy_and_clear_or_interrupt";
      "ctrl+c" = "copy_and_clear_or_interrupt";
      "${alt}+1" = "goto_tab 1";
      "${alt}+2" = "goto_tab 2";
      "${alt}+3" = "goto_tab 3";
      "${alt}+4" = "goto_tab 4";
      "${alt}+5" = "goto_tab 5";
      "${alt}+6" = "goto_tab 6";
      "${alt}+7" = "goto_tab 7";
      "${alt}+8" = "goto_tab 8";
      "${alt}+9" = "goto_tab 9"; # if less than 9 tabs, goes to last tab
      "${alt}+0" = "goto_tab -1"; # previously active tab
      "${alt}+shift+\\" = "launch --location=vsplit";
      "${alt}+shift+-" = "launch --location=hsplit";
      "ctrl+shift+h" = "kitty_scrollback_nvim";
      "ctrl+shift+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
      "alt+shift+h" = "neighboring_window left";
      "alt+shift+l" = "neighboring_window right";
      "alt+shift+k" = "neighboring_window up";
      "alt+shift+j" = "neighboring_window down";
      "ctrl+q>h" = "neighboring_window left";
      "ctrl+q>l" = "neighboring_window right";
      "ctrl+q>k" = "neighboring_window up";
      "ctrl+q>j" = "neighboring_window down";
    };
    extraConfig = ''
      mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
    '';
    actionAliases =
      if config.programs.neovim.enable then
        {
          "kitty_scrollback_nvim" =
            "kitten ${config.home.homeDirectory}/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py";
        }
      else
        { };
  };
  programs = {
    bash.bashrcExtra = ''
      if [ "$TERM" = "xterm-kitty" ]; then
          alias ssh="kitty +kitten ssh"
          alias icat="kitty +kitten icat"
      fi
      if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
          alias clip="kitty +kitten clipboard"
      fi
    '';
    zsh.initContent = ''
      if [ "$TERM" = "xterm-kitty" ]; then
          alias ssh="kitty +kitten ssh"
          alias icat="kitty +kitten icat"
      fi
      if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
          alias clip="kitty +kitten clipboard"
      fi
    '';
    fish.interactiveShellInit = ''
      if test "$TERM" = "xterm-kitty"
          abbr --add ssh "kitty +kitten ssh"
          abbr --add icat "kitty +kitten icat"
      end;
      if test -n "$SSH_CLIENT" -o -n "$SSH_TTY"
          abbr --add clip "kitty +kitten clipboard"
      end;
    '';
  };
}
