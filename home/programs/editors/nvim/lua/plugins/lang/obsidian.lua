local uuid = function()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function(c)
    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format('%x', v)
  end)
end

local obsidian_path = vim.fn.expand '~' .. '/Obsidian'

return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  -- lazy = false,
  -- ft = 'markdown',

  cmd = {
    'Obsidian',
  },

  event = {
    'BufReadPre ' .. obsidian_path .. '/*.md',
    'BufNewFile ' .. obsidian_path .. '/*.md',
  },
  keys = {
    { '<leader>fo', '<cmd>Obsidian quick_switch<CR>', desc = 'Obsidian: Quick Switch' },
  },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',
  },
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    footer = {
      enabled = false,
    },
    workspaces = {
      {
        name = 'personal',
        path = '~/Obsidian',
      },
    },
    completion = {
      nvim_cmp = false,
      blink = true,
      min_chars = 2,
    },
    ui = {
      enable = false,
    },
    -- templates = {
    --   folder = "90 - System/LuaTemplates",
    --   date_format = "%Y-%m-%d",
    --   time_format = "%H:%M",
    --   substitutions = {
    --     yesterday = function()
    --       return os.date("%Y-%m-%d", os.time() - 86400)
    --     end,
    --     uuid = uuid(),
    --   },
    -- },
    ---@return table
    frontmatter = {
      -- Update frontmatter in order
      func = function(note)
        local meta = note.metadata or {}

        -- ID: Rule: Generate if not present, never overwrite
        local note_id = meta.uuid
        if note_id == nil then
          note_id = uuid()
        end

        -- Aliases: Always ensure filename is in aliases
        local aliases = meta.aliases or note.aliases or {}
        if type(aliases) ~= 'table' then
          aliases = { aliases }
        end

        if note.title and note.id and note.title ~= note.id then
          local is_duplicate = false
          for _, v in pairs(aliases) do
            if v == note.id then
              is_duplicate = true
              break
            end
          end

          if not is_duplicate then
            table.insert(aliases, note.id)
          end
        end

        local out = {
          uuid = note_id,
          aliases = aliases,
          tags = meta.tags or note.tags,
          title = meta.title or note.id, -- 优先保留 metadata 中的 title，否则用 note.id
        }

        out = vim.tbl_extend('force', out, meta)

        out.modified = os.date('%Y-%m-%dT%H:%M:%S')

        if out.created == nil then
          out.created = os.date('%Y-%m-%dT%H:%M:%S')
        end

        return out
      end,
    },
    daily_notes = {
      folder = '40_Journal',
      date_format = '%Y-%m-%d',
      -- default_tags = { "daily" },
      template = nil,
    },
    -- see below for full list of options 👇
    attachments = {
      folder = '00_Meta/Assets',
      img_name_func = function()
        return string.format('%s-', os.time())
      end,
    },
    mappings = {
      ['<cr>'] = {
        action = function()
          require('obsidian').util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
    new_notes_location = 'current_dir',
  },
}
