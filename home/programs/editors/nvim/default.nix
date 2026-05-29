{
  pkgs,
  config,
  lib,
  ...
}:
let
  nvimAlias = {
    "v" = "nvim";
    "g" = "nvim +Neogit";
  };
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dots = config.nixdots.core.dots;
  snippets = (import ../lsp-snippets { inherit pkgs config; }).out;
  withImg = config.programs.kitty.enable || config.programs.ghostty.enable;
  appname = "nvim";
in
{
  imports = [ ../. ];
  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
    defaultEditor = true;
    withNodeJs = false;
    withPerl = false;
    withRuby = false;
    withPython3 = false;
    extraPackages =
      with pkgs;
      [
        # lua devenvs (luajit)
        lua5_1
        lua51Packages.luarocks
        lua-language-server
        stylua
        # tree-sitter
        tree-sitter
        # copilot-lua
        nodejs-slim_24
        vimPlugins.nvim-treesitter-parsers.diff
        vimPlugins.nvim-treesitter-parsers.nix
        # snacks.image
        pkg-config
        vimPlugins.nvim-treesitter-parsers.latex
        markdown-oxide
        # cli deps
        ripgrep
        ast-grep
        # cc
        clang
      ]
      ++ (lib.optionals withImg) (
        with pkgs;
        [
          mermaid-cli
          imagemagick
          tectonic
          ghostscript_headless
        ]
      );
    extraLuaPackages =
      ps:
      [
        ps.tree-sitter-cli
      ]
      ++ lib.optionals withImg [
        ps.magick
      ];
  };

  nixdots.devenvs.lua.enable = true;

  # home.packages = with pkgs; [lua-language-server];
  misc.shellAliases = nvimAlias;

  xdg.configFile."${appname}".source = mkSymlink "${dots}/home/programs/editors/nvim";

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

  nixdots.persist.home = {
    directories = [
      # nvim(lazy) will download plugins to this dir
      ".local/share/${appname}"
      ".local/state/${appname}"
    ];
  };
}
