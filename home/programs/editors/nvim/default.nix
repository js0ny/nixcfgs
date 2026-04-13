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
    defaultEditor = true;
    extraPackages = with pkgs; [
      lua5_1
      lua51Packages.luarocks
      # image support
      pkg-config
      imagemagick
      stylua
      nodejs-slim_24 # for copilot-lua
      lua-language-server
      vimPlugins.nvim-treesitter-parsers.diff
      vimPlugins.nvim-treesitter-parsers.nix
      # Dependency of snacks.image
      tectonic
      vimPlugins.nvim-treesitter-parsers.latex
      mermaid-cli
      ghostscript_headless
      lsof # Opencode.nvim
      markdown-oxide
    ];
  };
  # home.packages = with pkgs; [lua-language-server];
  nixdots.programs.shellAliases = nvimAlias;

  xdg.configFile."nvim".source = mkSymlink "${dots}/home/programs/editors/nvim/nvim";

  xdg.configFile."lsp-snippets".source = snippets;

  stylix.targets.neovim.enable = false;

  nixdots.persist.home = {
    directories = [
      # nvim(lazy) will download plugins to this dir
      ".local/share/nvim"
    ];
  };
}
