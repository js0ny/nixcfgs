{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      snacks.settings.image = {
        enabled = true;
        math = {
          enabled = true;
          font_size = "small";
        };
      };
      img-clip = {
        enable = true;
      };
    };
    extraPackages = with pkgs; [
      tectonic
      mermaid-cli
      ghostscript_headless
    ];
  };
}
