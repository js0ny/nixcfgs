{
  pkgs,
  config,
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
in
{
  imports = [ ../default.nix ];
  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
    defaultEditor = true;
    withNodeJs = false;
    withPerl = false;
    withRuby = false;
    withPython3 = false;
    extraPackages = with pkgs; [
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
      imagemagick
      tectonic
      vimPlugins.nvim-treesitter-parsers.latex
      mermaid-cli
      ghostscript_headless
      markdown-oxide
      # typst-preview.nvim
      tinymist
      websocat
      # cli deps
      ripgrep
    ];
  };

  nixdots.devenvs.lua.enable = true;

  # home.packages = with pkgs; [lua-language-server];
  nixdots.programs.shellAliases = nvimAlias;

  xdg.configFile."nvim".source = mkSymlink "${dots}/home/programs/editors/nvim/nvim";

  xdg.configFile."lsp-snippets".source = snippets;

  stylix.targets.neovim.enable = false;

  nixdots.persist.home = {
    directories = [
      # nvim(lazy) will download plugins to this dir
      ".local/share/nvim"
      ".local/state/nvim"
    ];
  };
}
