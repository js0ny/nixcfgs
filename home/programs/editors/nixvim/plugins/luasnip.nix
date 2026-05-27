{ config, ... }:
{
  programs.nixvim.plugins.luasnip = {
    enable = true;
    fromVscode = [ { paths = "${config.xdg.configHome}/lsp-snippets"; } ];
    settings = {
      history = true;
      enable_autosnippets = true;
    };
  };
}
