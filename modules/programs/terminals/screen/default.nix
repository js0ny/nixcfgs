{
  flake.nixosModules.screen = _: {
    programs.screen.enable = true;
    programs.screen.screenrc = builtins.readFile ./screenrc;
  };
  flake.homeModules.screen =
    { pkgs, config, ... }:
    {
      home.packages = [ pkgs.screen ];
      home.sessionVariables = {
        SCREENRC = "${config.xdg.configHome}/screen/screenrc";
        SCREENDIR = "$XDG_RUNTIME_DIR/screen";
      };
      xdg.configFile."screen/screenrc".text = builtins.readFile ./screenrc;
    };
}
