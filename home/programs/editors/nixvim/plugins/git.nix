{ ... }:
{
  programs.nixvim = {
    plugins = {
      neogit.enable = true;
      diffview.enable = true;
      web-devicons.enable = true;
      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };
    };

    keymaps = [
      {
        key = "<leader>G";
        action = "<Cmd>Neogit<CR>";
        options.desc = "Neogit";
      }
      {
        key = "<leader>gg";
        action = "<Cmd>Neogit<CR>";
        options.desc = "Neogit";
      }
      {
        key = "<leader>gd";
        action = "<Cmd>DiffviewOpen<CR>";
        options.desc = "Diffview";
      }
      {
        key = "<leader>gb";
        action = "<cmd>Gitsigns blame<CR>";
        options.desc = "Blame file";
      }
      {
        key = "<leader>gB";
        action = "<cmd>Gitsigns toggle_current_line_blame<CR>";
        options.desc = "Toggle line blame";
      }
      {
        key = "[g";
        action = "<cmd>Gitsigns prev_hunk<CR>";
        options.desc = "Prev hunk";
      }
      {
        key = "]g";
        action = "<cmd>Gitsigns next_hunk<CR>";
        options.desc = "Next hunk";
      }
    ];
  };
}
