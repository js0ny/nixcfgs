{ config, ... }:
let
  lsp = config.nixdefs.lsp.servers;
  nixd = lsp.nixd;
in
{
  programs.nixvim = {
    plugins.lspconfig.enable = true;
    plugins.lsp.servers = {
      nixd = {
        enable = true;
        autostart = true;
        config = nixd.client // {
          settings = nixd.serverSettings;
        };
      };
      nil_ls = {
        enable = true;
        autostart = true;
        onAttach.function = /* lua */ ''
          if client.name == 'nil_ls' then
            client.server_capabilities.definitionProvider = false -- use nixd
          end
        '';
      };
      copilot = {
        enable = true;
        autostart = true;
      };
    };
    keymaps = [
      {
        key = "<C-CR>";
        action.__raw = "vim.lsp.buf.definition";
        options.desc = "Goto Definition";
      }
      {
        key = "gi";
        action.__raw = "vim.lsp.buf.implementation";
        options.desc = "Goto Implementation";
        mode = [ "n" ];
      }
      {
        key = "<leader>,";
        action.__raw = "vim.lsp.buf.code_action";
        options.desc = "Code Action";
        mode = [ "n" ];
      }
      {
        key = "ga";
        action.__raw = "vim.lsp.buf.code_action";
        options.desc = "Code Action";
        mode = [ "n" ];
      }
      {
        key = "g.";
        action.__raw = "vim.lsp.buf.code_action";
        options.desc = "Code Action";
        mode = [ "n" ];
      }
      {
        key = "gh";
        action.__raw = "vim.lsp.buf.hover";
        options.desc = "Show hover";
        mode = [ "n" ];
      }
      {
        key = "cd";
        action.__raw = "vim.lsp.buf.rename";
        options.desc = "Rename symbol under cursor";
        mode = [ "n" ];
      }
    ];
  };
}
