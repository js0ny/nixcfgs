{ ... }:
{
  programs.nixvim.plugins.blink-pairs = {
    enable = true;
    extraConfigLua = ''
      require('blink.pairs').setup({
        mappings = {
          enabled = true,
          cmdline = true,
          disabled_filetypes = {},
          pairs = {
            ["'"] = {
              "'''",
              when = function(ctx)
                return ctx:text_before_cursor(1) == "'"
              end,
              languages = { 'nix' },
            },
            ['`'] = {
              {
                '```',
                when = function(ctx)
                  return ctx:text_before_cursor(2) == '``'
                end,
                languages = { 'vimwiki' },
              },
              {
                '`',
                "'",
                languages = { 'bibtex', 'latex', 'plaintex' },
              },
              {
                '`',
                enter = false,
                space = false,
                when = function(ctx)
                  if ctx.ft == 'markdown' then
                    return ctx:text_before_cursor(2) ~= '``'
                  elseif ctx.ft == 'typst' then
                    return ctx:text_before_cursor(2) ~= '``'
                  end
                  return true
                end,
              },
            },
          },
        },
        highlights = {
          enabled = true,
          cmdline = true,
          groups = {
            'BlinkPairsOrange',
            'BlinkPairsPurple',
            'BlinkPairsBlue',
          },
          unmatched_group = 'BlinkPairsUnmatched',
          matchparen = {
            enabled = true,
            cmdline = false,
            include_surrounding = false,
            group = 'BlinkPairsMatchParen',
            priority = 250,
          },
        },
      })
    '';
  };
}
