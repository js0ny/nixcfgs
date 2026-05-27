{ ... }:
{
  programs.nixvim = {
    dependencies.tree-sitter.enable = true;

    plugins = {
      treesitter.enable = true;
      treesj = {
        enable = true;
        settings.use_default_keymaps = false;
      };
      treesitter-textobjects = {
        enable = true;
        settings = {
          select = {
            lookahead = true;
            include_surrounding_whitespace = true;
          };
          move.set_jumps = true;
        };
      };
      ts-autotag.enable = true;
      ts-comments.enable = true;
      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 5;
          mode = "topline";
        };
      };
    };

    keymaps = [
      {
        key = "<leader>tc";
        action.__raw = "function() require('treesitter-context').toggle() end";
        options.desc = "Treesitter Context";
      }
      {
        key = "gJ";
        action.__raw = "function() require('treesj').join() end";
        options.desc = "Join lines";
      }
    ];
    extraConfigLua = ''
      -- Start treesitter for specific filetypes
      local base_ft = {
        'lua',
        'html',
        'markdown',
        'nix',
        'nu',
        'yaml',
        'kdl',
        'json',
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = base_ft,
        callback = function(ev)
          vim.treesitter.start(ev.buf, ev.match)
        end,
      })
    '';
  };
}
