local fcitx5_remote = vim.fn.exepath('fcitx5-remote')

if fcitx5_remote == '' then
  return
end

local previous_layout = nil

local function switch_to_en()
  previous_layout = vim.trim(vim.fn.system({ fcitx5_remote, '-n' }))
  vim.fn.system({ fcitx5_remote, '-s', 'keyboard-us' })
end

local function restore_layout()
  if previous_layout and previous_layout ~= '' then
    vim.fn.system({ fcitx5_remote, '-s', previous_layout })
  end
end

vim.opt.ttimeoutlen = 150

local group = vim.api.nvim_create_augroup('InputMethod', { clear = true })

vim.api.nvim_create_autocmd('InsertLeave', {
  group = group,
  callback = switch_to_en,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  group = group,
  callback = restore_layout,
})
