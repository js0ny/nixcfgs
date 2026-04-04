-- Check if Copilot is enabled for current buffert
-- :Copilot status

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "BufReadPost",
  enabled = vim.g.ai_enabled,
  opts = {
    suggestion = {
      auto_trigger = true,
      -- hide_during_completion = vim.g.ai_cmp,
      keymap = {
        accept = "<M-l>", -- Inspired from zed
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
    -- Disable <M-CR> to open Copilot panel
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
      beancount = false,
      yaml = false,
      -- Disable for .env files
      sh = function()
        if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
          return false
        end
        return true
      end,
      -- Disable for rclone.conf
      conf = function()
        if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^rclone%.conf$") then
          return false
        end
        return true
      end,
    },
  },
}
