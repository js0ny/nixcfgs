local M = {}
-- local mode_arrow = { "n", "v", "o", "s", "x" }

local default_opts = { noremap = true, silent = true }
local default_mode = { "n" }

function M.set_keymaps(maps)
  for _, map in ipairs(maps) do
    local opts = vim.tbl_extend("force", default_opts, map.opts or {})
    local mode = map.mode or default_mode
    vim.keymap.set(mode, map.keys, map.cmd, opts)
  end
end

function M.set_lang_keymaps(maps)
  vim.api.create_autocmd("FileType", {
    pattern = maps.filetype,
    callback = function()
      M.set_keymaps(maps.keymaps)
    end,
  })
end

-- This fuction is used in ftplugin/*.lua
function M.set_buf_keymaps(maps)
  if not maps then
    return
  end
  for _, map in ipairs(maps) do
    local opts = vim.tbl_extend("force", map.opt or {}, { buffer = true })
    vim.keymap.set(map.mode, map.keys, map.cmd, opts)
  end
end

function M.set_buf_keymaps_prefix(maps)
  local n_prefix = "<leader>m"
  local i_prefix = "<C-;>" -- Using C-M will stuck when <CR>
  if not maps then
    return
  end
  for _, map in ipairs(maps) do
    local opts = vim.tbl_extend("force", map.opt or {}, { buffer = true })
    vim.keymap.set("n", n_prefix .. map.keys, map.cmd, opts)
    vim.keymap.set("i", i_prefix .. map.keys, map.cmd, opts)
  end
end

return M
