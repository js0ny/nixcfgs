{ pkgs, ... }:
{
  imports = [
    ./piper.nix
    ./keymaps.nix
    ./plugins.nix
  ];
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    shellWrapperName = "y";
    settings = {
      preview.wrap = "yes";
      mgr = {
        show_hidden = true;
        linemode = "size_and_mtime";
      };

    };

    initLua = builtins.readFile ./init.lua;
  };
  home.packages = with pkgs; [
    (ouch.override { enableUnfree = pkgs.stdenv.hostPlatform.isLinux; })
  ];
}
