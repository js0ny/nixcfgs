vim.api.nvim_create_user_command('Format', function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end
  require('conform').format({ async = true, lsp_format = 'fallback', range = range })
end, { range = true })

vim.api.nvim_create_user_command('FormatToggle', function(args)
  local buffer_local = args.bang
  if buffer_local then
    vim.b.disable_autoformat = not vim.b.disable_autoformat
  else
    vim.g.disable_autoformat = not vim.g.disable_autoformat
  end

  local scope = buffer_local and 'buffer' or 'global'
  local status = buffer_local and vim.b.disable_autoformat or vim.g.disable_autoformat
  print(string.format('Format-on-save %s: %s', scope, status and 'disabled' or 'enabled'))
end, {
  desc = 'Toggle autoformat-on-save (use ! for buffer-local)',
  bang = true,
})

vim.api.nvim_create_user_command('Rename', function()
  local old_name = vim.api.nvim_buf_get_name(0)
  if old_name == '' then
    vim.notify('Current buffer has no file name', vim.log.levels.WARN)
    return
  end

  local old_buf = vim.api.nvim_get_current_buf()
  vim.ui.input({ prompt = 'New name: ', default = old_name }, function(new_name)
    if not new_name or new_name == '' or new_name == old_name then
      return
    end

    vim.cmd.write()

    local ok, err = os.rename(old_name, new_name)
    if not ok then
      vim.notify('Error renaming file: ' .. err, vim.log.levels.ERROR)
      return
    end

    vim.cmd.edit(vim.fn.fnameescape(new_name))
    if vim.api.nvim_buf_is_valid(old_buf) then
      vim.api.nvim_buf_delete(old_buf, { force = true })
    end
  end)
end, {
  desc = 'Rename current file',
})
