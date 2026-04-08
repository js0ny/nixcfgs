local uuid = function()
  local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  return string.gsub(template, "[xy]", function(c)
    local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format("%x", v)
  end)
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  -- lazy = false,
  ft = "markdown",

  cmd = {
    "Obsidian",
  },
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  keys = {
    { "<leader>fo", "<cmd>ObsidianQuickSwitch<CR>", desc = "Obsidian: Quick Switch" },
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  opts = {
    legacy_commands = false,
    footer = {
      enabled = false,
    },
    workspaces = {
      {
        name = "personal",
        path = "~/Obsidian",
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
    templates = {
      folder = "90 - System/LuaTemplates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {
        yesterday = function()
          return os.date("%Y-%m-%d", os.time() - 86400)
        end,
        uuid = uuid(),
      },
    },
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
        if type(aliases) ~= "table" then
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

        -- 5. 合并其他自定义 Metadata
        -- 使用 vim.tbl_extend "force" 策略：
        -- 将 current_metadata 中的所有字段强制合并到 out 中。
        -- 这样可以确保：所有手动添加的字段（如 author, category 等）都不会丢失。
        -- 同时，如果 metadata 里本来就有 id，这里会再次确认覆盖，保证一致性。
        out = vim.tbl_extend("force", out, meta)

        -- 6. 强制更新 mtime (这是你希望每次保存都更新的)
        out.mtime = os.date("%Y-%m-%dT%H:%M:%S")

        -- 7. 保持 date (创建时间) 不变
        -- 如果 metadata 里没有 date，也许你想补一个？如果不需要，可以删掉下面这行
        if out.date == nil then
          out.date = os.date("%Y-%m-%dT%H:%M:%S")
        end

        return out
      end,
    },
    daily_notes = {
      folder = "00 - Journal/Daily",
      date_format = "%Y-%m-%d",
      -- default_tags = { "daily" },
      template = nil,
    },
    -- see below for full list of options 👇
    attachments = {
      folder = "90 - System/Assets",
      img_name_func = function()
        return string.format("%s-", os.time())
      end,
    },
    -- mappings = {
    --   ["<cr>"] = {
    --     action = function()
    --       require("obsidian").util.smart_action()
    --     end,
    --     opts = { buffer = true, expr = true },
    --   },
    -- },
    new_notes_location = "current_dir",
  },
}
