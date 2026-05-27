{ ... }:
{
  programs.nixvim.plugins.blink-cmp = {
    enable = true;
    settings = {
      keymap = {
        preset = "default";
        "<Tab>" = [
          "snippet_forward"
          "fallback"
        ];
        "<C-f>" = [ "select_and_accept" ];
        "<C-b>" = [
          "hide"
          "fallback"
        ];
      };
      completion = {
        menu.border = "single";
        documentation.window.border = "single";
      };
      signature.window.border = "single";
      appearance.nerd_font_variant = "normal";
      snippets.preset = "luasnip";
      cmdline = {
        keymap = {
          preset = "cmdline";
          "<CR>" = [ "fallback" ];
          "<C-f>" = [
            "select_and_accept"
            "fallback"
          ];
          "<C-a>" = [ ];
        };
        completion = {
          menu.auto_show = false;
        };
      };
      sources = {
        default = [
          "lazydev"
          "lsp"
          "path"
          "snippets"
        ];
        per_filetype = {
          org = [ "orgmode" ];
          markdown = [
            "lsp"
            "path"
            "snippets"
          ];
        };
        providers = {
          lazydev = {
            name = "LazyDev";
            module = "lazydev.integrations.blink";
            score_offset = 100;
          };
        };
      };
      fuzzy.implementation = "prefer_rust_with_warning";
    };
    settingsExtend = [ "sources.default" ];

    extraConfigLua = ''
      local MATH_NODES = {
        displayed_equation = true,
        inline_formula = true,
        math_environment = true,
        latex_block = true,
        math = true,
        math_block = true,
        inline_math = true,
        equation = true,
        equation_environment = true,
      }

      local disabled_ft = { 'TelescopePrompt', 'dap-repl', 'snacks_picker_list' }

      require('blink.cmp').setup({
        enabled = function()
          if vim.fn.getcmdtype() ~= '''' then
            return true
          end
          return not vim.tbl_contains(disabled_ft, vim.bo.filetype)
        end,
        keymap = {
          ['<CR>'] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.accept()
              else
                return cmp.select_and_accept()
              end
            end,
            'fallback',
          },
        },
        sources = {
          providers = {
            snippets = {
              enabled = function()
                if vim.bo.filetype ~= 'markdown' then
                  return true
                end
                local ok, node = pcall(vim.treesitter.get_node)
                if not ok or not node then
                  return false
                end
                while node do
                  if MATH_NODES[node:type()] then
                    return true
                  end
                  node = node:parent()
                end
                return false
              end,
            },
            lazydev = {
              name = 'LazyDev',
              module = 'lazydev.integrations.blink',
              score_offset = 100,
            },
          },
        },
      })
    '';
  };
}
