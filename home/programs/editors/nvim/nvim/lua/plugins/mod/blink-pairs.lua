return {
  "saghen/blink.pairs",
  version = "*", -- use prebuilt version
  event = "BufEnter",

  -- download binary
  dependencies = "saghen/blink.download",

  --- @module 'blink.pairs'
  --- @type blink.pairs.Config
  opts = {
    mappings = {
      enabled = true,
      cmdline = true,
      disabled_filetypes = {},
      -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#24
      pairs = {
        ["'"] = {
          "''",
          when = function(ctx)
            return ctx:text_before_cursor(1) == "'"
          end,
          languages = { "nix" },
        },
        ["`"] = {
          -- 使用 luasnip 接管 ``` 的行为
          {
            "```",
            when = function(ctx)
              return ctx:text_before_cursor(2) == "``"
            end,
            languages = { "typst", "vimwiki" },
          },
          {
            "`",
            "'",
            languages = { "bibtex", "latex", "plaintex" },
          },
          {
            "`",
            enter = false,
            space = false,
            when = function(ctx)
              if ctx.ft == "markdown" then
                return ctx:text_before_cursor(2) ~= "``"
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
        "BlinkPairsOrange",
        "BlinkPairsPurple",
        "BlinkPairsBlue",
      },
      unmatched_group = "BlinkPairsUnmatched",

      matchparen = {
        enabled = true,
        cmdline = false,
        include_surrounding = false,
        group = "BlinkPairsMatchParen",
        priority = 250,
      },
    },
  },
}
