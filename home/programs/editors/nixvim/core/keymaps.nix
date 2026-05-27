{ ... }:
{
  programs.nixvim = {
    keymaps = [
      {
        key = "q:";
        action = ":";
        options.desc = "Disable command-line window";
      }
      {
        key = "<Esc>";
        mode = "n";
        action = "<Cmd>nohlsearch<Bar>diffupdate<CR>";
        options.desc = "Clear Search Highlight";
      }
    ];

    extraConfigLua = ''
      -- Smart split for LSP definitions
      local function smart_split(func, reverse)
        local width = vim.api.nvim_win_get_width(0)
        if width > 80 and not reverse then
          vim.api.nvim_command('vsp')
        else
          vim.api.nvim_command('sp')
        end
        func()
      end

      vim.keymap.set('n', '<C-w>d', function()
        smart_split(vim.lsp.buf.definition)
      end, { desc = 'Go to Definition (Smart Split)' })

      vim.keymap.set('n', '<C-w>D', function()
        smart_split(vim.lsp.buf.declaration, true)
      end, { desc = 'Go to Declaration (Smart Split)' })

      -- Remove default gra and gri
      vim.keymap.del({ 'n', 'x' }, 'gra')
      vim.keymap.del({ 'n' }, 'gri')
    '';
  };
}
