{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  nvimAlias = {
    "v" = "nvim";
    "g" = "nvim +Neogit";
  };
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  snippets = (import ../lsp-snippets { inherit pkgs config; }).out;
  withImg = config.programs.kitty.enable || config.programs.ghostty.enable;
  appname = "nvim";
  dots = config.nixdots.core.dots;
in
{
  imports = [
    ../.
    inputs.nvimdots.homeModules.default
  ];

  nixdots.devenvs.lua.enable = true;

  # home.packages = with pkgs; [lua-language-server];
  misc.shellAliases = nvimAlias;

  xdg.configFile."${appname}".source = mkSymlink "${dots}/modules/home/programs/editors/nvim";

  xdg.configFile."lsp-snippets".source = snippets;

  stylix.targets.neovim = {
    enable = true;
    plugin = "mini.base16";
    transparentBackground = {
      main = false;
      signColumn = false;
      numberLine = false;
    };
  };

  nixdots.persist.nosnap.home = {
    directories = [
      # nvim(lazy) will download plugins to this dir
      ".local/share/${appname}"
      ".local/state/${appname}"
    ];
  };
}
