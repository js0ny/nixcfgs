{ ... }:
{
  programs.nixvim.plugins.lazydev = {
    enable = true;
    settings = {
      library = [
        {
          path = "\${3rd}/luv/library";
          words = [ "vim%.uv" ];
        }
      ];
      enabled.__raw = ''
        function()
          return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
        end
      '';
    };
  };
}
