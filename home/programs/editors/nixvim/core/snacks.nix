{ config, ... }:
let
  flake = config.nixdots.core.flakeDir;
  dots = config.nixdots.core.dots;
in
{
  programs.nixvim = {
    plugins.snacks = {
      enable = true;
      globals = {
        loaded_netrw = 1;
        loaded_netrwPlugin = 1;
      };
      settings = {
        bigfile.enabled = true;
        indent.enabled = true;
        input.enabled = true;
        notifier.enabled = true;
        quickfile.enabled = true;
        scope.enabled = true;
        scroll.enabled = false;
        statuscolumn.enabled = true;
        picker = {
          enabled = true;
          ui_select = true;
        };
      };
    };

    keymaps = [
      {
        key = "<M-x>";
        action.__raw = ''function() require("snacks").picker.commands() end'';
        options.desc = "All commands";
      }
      {
        key = "<leader>;";
        action.__raw = ''function() require("snacks").picker.commands() end'';
        options.desc = "Show Commands";
      }
      {
        key = "<leader><Space>";
        action.__raw = ''function() require("snacks").picker.smart() end'';
        options.desc = "Smart Find Files";
      }
      {
        key = "<leader>/";
        action.__raw = ''function() require("snacks").picker.grep() end'';
        options.desc = "Grep Files";
      }
      {
        key = "<leader>R";
        action.__raw = ''function() require("snacks").picker.resume() end'';
        options.desc = "Resume Picker";
      }
      {
        key = "<leader>ff";
        action.__raw = ''function() require("snacks").picker.files() end'';
        options.desc = "Find Files";
      }
      {
        key = "<leader>fb";
        action.__raw = ''function() require("snacks").picker.buffers() end'';
        options.desc = "List Buffers";
      }
      {
        key = "<leader>bB";
        action.__raw = ''function() require("snacks").picker.buffers() end'';
        options.desc = "List Buffers";
      }
      {
        key = "<leader>fh";
        action.__raw = ''function() require("snacks").picker.recent() end'';
        options.desc = "Recent Files";
      }
      {
        key = "<leader>fc";
        action.__raw = ''function() require("snacks").picker.files({ cwd = "${flake}" }) end'';
        options.desc = "Edit Configs";
      }
      {
        key = "<leader>fd";
        action.__raw = ''function() require("snacks").picker.files({ cwd = "${dots}" }) end'';
        options.desc = "Pick dotfiles";
      }
      {
        key = "<leader>fF";
        action.__raw = ''function() require("snacks").picker.files() end'';
        options.desc = "Pick flakeDir";
      }
      {
        key = "<leader>gs";
        action.__raw = ''function() require("snacks").picker.git_status() end'';
        options.desc = "Git Status";
      }
      {
        key = "<leader>gt";
        action.__raw = ''function() require("snacks").picker.git_branches() end'';
        options.desc = "Git Branches";
      }
      {
        key = "<leader>gc";
        action.__raw = ''function() require("snacks").picker.git_log() end'';
        options.desc = "Git Log (Commits)";
      }
      {
        key = "<leader>cs";
        action.__raw = ''function() require("snacks").picker.lsp_symbols() end'';
        options.desc = "Search Symbols";
      }
      {
        key = "<leader>cS";
        action.__raw = ''function() require("snacks").picker.grep_word() end'';
        options.desc = "Search Current Symbol";
        mode = [
          "n"
          "x"
        ];
      }
      {
        key = "<leader>sd";
        action.__raw = ''function() require("snacks").picker.diagnostics() end'';
        options.desc = "Diagnostics";
      }
      {
        key = "<leader>sD";
        action.__raw = ''function() require("snacks").picker.diagnostics() end'';
        options.desc = "Diagnostics";
      }
      {
        key = "<leader>ui";
        action.__raw = ''function() require("snacks").picker.colorschemes() end'';
        options.desc = "Change Colorscheme";
      }
      {
        key = "<leader>pd";
        action.__raw = ''function() require("snacks").picker.zoxide() end'';
        options.desc = "List Recent Directories (Zoxide)";
      }
      {
        key = "<leader>:";
        action.__raw = ''function() require("snacks").picker() end'';
        options.desc = "Pick Snacks";
      }
      {
        key = "gd";
        action.__raw = ''function() require("snacks").picker.lsp_definitions() end'';
        options.desc = "Goto Definition";
      }
      {
        key = "gr";
        action.__raw = ''function() require("snacks").picker.lsp_references() end'';
        options.desc = "References";
        options.nowait = true;
      }
      {
        key = "gy";
        action.__raw = ''function() require("snacks").picker.lsp_type_definitions() end'';
        options.desc = "Goto T[y]pe Definition";
      }
    ];
  };
}
