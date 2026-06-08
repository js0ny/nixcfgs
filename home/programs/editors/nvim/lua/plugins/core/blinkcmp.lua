local disabled_ft = { 'TelescopePrompt', 'dap-repl', 'snacks_picker_list' }

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

return {
  'saghen/blink.cmp',

  -- use a release tag to download pre-built binaries
  version = '*',
  event = { 'InsertEnter', 'CmdlineEnter' },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    enabled = function()
      if vim.fn.getcmdtype() ~= '' then
        return true
      end
      return not vim.tbl_contains(disabled_ft, vim.bo.filetype)
    end,
    keymap = {
      preset = 'default',
      ['<Tab>'] = {
        'snippet_forward',
        'fallback',
      },
      ['<C-f>'] = { 'select_and_accept' },
      ['<C-b>'] = { 'hide', 'fallback' },
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
    completion = {
      menu = {
        border = 'single',
        draw = {
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
            { 'source' },
          },

          components = {
            source = {
              width = { max = 20 },
              text = function(ctx)
                local source = ctx.source_name

                if ctx.source_id == 'lsp' and ctx.item and ctx.item.client_id then
                  local client = vim.lsp.get_client_by_id(ctx.item.client_id)
                  if client then
                    source = client.name
                  end
                end

                return ' ' .. source
              end,
              highlight = 'BlinkCmpSource',
            },
          },
        },
      },
      documentation = { auto_show = true, window = { border = 'single' } },
    },
    signature = { window = { border = 'single' } },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'normal',
    },

    snippets = {
      preset = 'luasnip',
    },

    cmdline = {
      keymap = {
        preset = 'cmdline',
        ['<CR>'] = { 'fallback' },
        ['<C-f>'] = { 'select_and_accept', 'fallback' },
      },
      completion = {
        menu = { auto_show = false },
        -- documentation = { auto_show = true }, --, auto_show_delay_ms = 1000 },
      },
    },

    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets' }, -- , 'buffer' },
      per_filetype = {
        org = { 'orgmode' },
        markdown = { 'lsp', 'path', 'snippets' },
      },
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

    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
