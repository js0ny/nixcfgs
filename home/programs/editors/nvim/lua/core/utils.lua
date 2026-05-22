local M = {}

local default_opts = { noremap = true, silent = true }
local default_mode = { 'n' }

function M.set_keymaps(maps)
  for _, map in ipairs(maps) do
    local opts = vim.tbl_extend('force', default_opts, map.opts or {})
    local mode = map.mode or default_mode
    vim.keymap.set(mode, map.keys, map.cmd, opts)
  end
end

function M.set_buf_keymaps(maps)
  if not maps then
    return
  end
  for _, map in ipairs(maps) do
    local opts = vim.tbl_extend('force', map.opt or {}, { buffer = true })
    vim.keymap.set(map.mode, map.keys, map.cmd, opts)
  end
end

function M.exepath(name)
  local path = vim.fn.exepath(name)
  return path ~= '' and path or nil
end

return M
