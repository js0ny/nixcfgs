vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

vim.opt_local.spelllang = { "en_us", "cjk" }
vim.opt_local.spell = true

local bufmap = {
  { mode = "x", keys = "mi", cmd = 'c*<C-r>"*', opt = { desc = "Add italic to selected text" } },
  { mode = "x", keys = "mb", cmd = 'c**<C-r>"**', opt = { desc = "Add bold to selected text" } },
  { mode = "x", keys = "mc", cmd = 'c`<CR><C-r>"<CR>`', opt = { desc = "Add code block to selected text" } },
  { mode = "x", keys = "mD", cmd = 'c~~<C-r>"~~', opt = { desc = "Add strikethrough to selected text" } },
  { mode = "x", keys = "mh", cmd = 'c==<C-r>"==', opt = { desc = "Add highlight to selected text" } },
  { mode = "n", keys = "J", cmd = "<Nop>" },
  {
    mode = "n",
    keys = "<Tab>",
    cmd = "<Cmd>silent! normal! za<CR>",
    opt = { desc = "Toggle folding under current level (silent)" },
  },
}

-- local set_buf_keymaps_prefix = require("keymaps.utils").set_buf_keymaps_prefix
local set_buf_keymaps = require("keymaps.utils").set_buf_keymaps

set_buf_keymaps(bufmap)
