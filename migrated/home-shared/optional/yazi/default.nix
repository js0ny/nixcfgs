{ ... }:
{
  imports = [
    ./piper.nix
    ./keymaps.nix
    ./opener.nix
    ./plugins.nix
  ];
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    shellWrapperName = "y";
    # https://yazi-rs.github.io/docs/configuration/yazi/
    settings = {
      preview.wrap = "yes";
      mgr = {
        show_hidden = true;
        linemode = "size_and_mtime";
      };
    };

    initLua = builtins.readFile ./init.lua;
  };
}
