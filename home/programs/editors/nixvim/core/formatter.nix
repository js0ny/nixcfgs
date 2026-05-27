{ ... }:
{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          nu = [ "nufmt" ];
          python = [ "ruff" ];
          javascript = [ "prettier" ];
          kdl = [ "kdlfmt" ];
        };
        default_format_opts = {
          lsp_format = "fallback";
        };
        formatters = {
          shfmt = {
            prepend_args = [
              "-i"
              "2"
            ];
          };
        };
      };
    };

    extraConfigLua = ''
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    '';
  };
}
