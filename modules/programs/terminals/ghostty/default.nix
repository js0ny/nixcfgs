{
  flake.homeModules.ghostty =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      shell = config.nixdots.apps.interactiveShell.package;
    in
    {
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
        systemd.enable = if pkgs.stdenv.isDarwin then false else true;
        settings = {
          env = [
            "COLORTERM=truecolor"
            "TERM_PROGRAM=ghostty"
          ];
          command = lib.getExe shell;
          cursor-style = "block_hollow";
          cursor-style-blink = true;
          cursor-click-to-move = true;
          cursor-invert-fg-bg = true;
          window-decoration = "auto";
          macos-option-as-alt = "left";
          keybind = [
            "performable:ctrl+c=copy_to_clipboard"
            "alt+shift+h=goto_split:left"
            "alt+shift+j=goto_split:bottom"
            "alt+shift+k=goto_split:top"
            "alt+shift+l=goto_split:right"
            "alt+shift+|=new_split:right"
            "alt+shift+_=new_split:down"
            "alt+shift+enter=new_split:auto"
            "ctrl+enter=ignore"
          ];
          selection-clear-on-copy = true;
          copy-on-select = "clipboard";
        };
      };
      programs.zed-editor.extensions = [ "ghostty" ];
      targets.darwin.defaults."com.mitchellh.ghostty" = lib.mkIf pkgs.stdenv.isDarwin {
        SUEnableAutomaticChecks = 0;
        SUHasLaunchedBefore = 1;
        SUSendProfileInfo = 0;
      };
    };
}
