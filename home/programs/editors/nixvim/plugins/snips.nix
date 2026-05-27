{ ... }:
{
  programs.nixvim.extraConfigLuaPost = ''

    local ls = require('luasnip')
    local i = ls.insert_node

    ls.add_snippets('markdown', {
      ls.snippet({ trig = '```', trigEngine = 'plain' }, {
        ls.text_node({ '```', "" }),
        i(1),
        ls.text_node({ "", '```' }),
      }),
    }, { type = 'autosnippets' })

    ls.add_snippets('typst', {
      ls.snippet({ trig = '```', trigEngine = 'plain' }, {
        ls.text_node({ '```' }),
        i(1),
        ls.text_node({ "" }),
        i(2),
        ls.text_node({ "", '```' }),
      }),
      ls.snippet({ trig = 'mk', trigEngine = 'plain' }, {
        ls.text_node({ '$' }),
        i(1),
        ls.text_node({ '$' }),
      }),
      ls.snippet({ trig = 'dmi', trigEngine = 'plain' }, {
        ls.text_node({ '$ ' }),
        i(1),
        ls.text_node({ ' $' }),
      }),
      ls.snippet({ trig = 'dmm', trigEngine = 'plain' }, {
        ls.text_node({ '$', "" }),
        i(1),
        ls.text_node({ "" }),
        i(2),
        ls.text_node({ "", '$' }),
      }),
    }, { type = 'autosnippets' })
  '';
}
