-- Welcome to nvim's systemd :D

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
          -- stylua: ignore start
        keys = {
          -- { key = "p", icon = "󰈞 ", desc = "查找项目", action = "<cmd>Telescope projects<CR>" },
          { key = "h", icon = " ", desc = "历史文件", action = function () require("fzf-lua").oldfiles() end },
          { key = "l", icon = " ", desc = "加载会话", action = "<cmd>AutoSession search<CR>" },
          {
            key = "c",
            icon = " ",
            desc = "转到设置",
            action = function() require("fzf-lua").files({ cwd = "~/.config/nvim" }) end,
          },
          { key = "q", icon = "󱊷 ", desc = "退出", action = "<cmd>qa<CR>" },
        },
        --https://github.com/timteeee/.dotfiles/blob/main/.config/nvim/lua/plugins/snacks.lua
        header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀.⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀*.⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀.*%0.⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀&&*.⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀.*%%%00*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀&&&&*.⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀.*.⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀.*%%%%%000*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀&&&&&&*.⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀..*******.⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀.%@&'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀.*%%%%%%%00000⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀&&&&&&&&*.⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀.*0&%%@@@@@@@@@@@&0^⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀*@@@&'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
*00%%%%%%%000000.⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀&&&&&&&&&&*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀o&@@@@%&00*^^^''''^^*0%&'⠀⠀⠀⠀⠀⠀⠀*@@@&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
0000%%%%%%0000000*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀&&&&&&&&&&&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀'%@@%0^⠀.*.⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀&%000&&&&@@@@&&&0o⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
000000%%%%000000000.⠀⠀⠀⠀⠀⠀⠀⠀&&&&&&&&&&&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀0@*⠀⠀⠀0%@@0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀*@@&&000%@@@0^^'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
0000000%%%0000000000*⠀⠀⠀⠀⠀⠀⠀&&&&&&&&&&&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀00*@@0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀*&@%'⠀⠀⠀⠀0@@@0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀*.⠀⠀⠀⠀
00000000%%000000000000⠀⠀⠀⠀⠀⠀&&&&&&&&&&&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀0⠀*@@%⠀⠀⠀⠀⠀⠀⠀⠀.0%@@0'⠀⠀⠀⠀0@@@0⠀⠀⠀⠀⠀*%&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀&@%'⠀⠀⠀
000000000%'000000000000.⠀⠀⠀⠀&&&&&&&&&&&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀^⠀0@@%'⠀⠀⠀⠀⠀.o&@@&^⠀⠀⠀⠀⠀⠀0@@@0⠀⠀⠀⠀⠀*@@&⠀⠀.*.⠀⠀⠀⠀&@@0⠀⠀⠀⠀
0000000000⠀'000000000000.⠀⠀⠀&&&&&&&&&&&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀.*&@@%'⠀⠀.*0%@@&*'⠀⠀⠀⠀⠀⠀⠀*@@@0⠀⠀⠀⠀⠀*@@%⠀⠀.0@%⠀⠀⠀0@@*⠀⠀⠀⠀⠀
0000000000⠀⠀⠀'00000000000*⠀⠀&&&&&&&&&&&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀*0%@@@%%%@@@%0^⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀*@@@0⠀⠀⠀⠀⠀*@@%⠀⠀*%@@%⠀⠀*@@^⠀⠀⠀⠀⠀⠀
0000000000⠀⠀⠀⠀'000000000000.&&&&&&&&&&&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀@@@@@@@@@@@%0'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀'@@@&⠀⠀⠀⠀⠀*@@%⠀⠀&0%@@*⠀*@%'⠀⠀⠀⠀⠀⠀⠀
0000000000⠀⠀⠀⠀⠀⠀000000000000%&&&&&&&&&&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀0@@@^⠀⠀⠀⠀'^00%@&o.⠀⠀⠀⠀⠀⠀⠀%@@%'⠀⠀⠀⠀*@@@'.&^0@@%⠀*@%'⠀⠀⠀⠀⠀⠀⠀⠀
0000000000⠀⠀⠀⠀⠀⠀⠀^0000000000%%&&&&&&&&&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀'@@%'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀'0@@&'⠀⠀⠀⠀&@@@'⠀⠀⠀.&@@@⠀0&''@@@*o@&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
0000000000⠀⠀⠀⠀⠀⠀⠀⠀'000000000%%%%&&&&&&&⠀⠀⠀⠀⠀⠀⠀⠀⠀'@@%'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀0@@@0⠀⠀⠀*@@@^⠀⠀.00@@@0&0⠀⠀%@@%0@0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
0000000000⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀00000000%%%%%%&&&&&⠀⠀⠀⠀⠀⠀⠀⠀'@@&⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀.0@@@@0⠀⠀⠀'@@@*⠀.*0'&@@@%*⠀⠀*@@@%@0⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
0000000000⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀'000000%%%%%%%%&&*⠀⠀⠀⠀⠀⠀⠀⠀%@0⠀⠀⠀⠀⠀⠀⠀⠀.*&%@@%&^⠀⠀⠀⠀⠀0@@&'0&^⠀^@@@@^⠀⠀⠀&@@@@*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀^00000000⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀'00000%%%%%%'.*.⠀⠀⠀⠀⠀⠀⠀⠀⠀*0'⠀⠀.*00&%@@@&0*'⠀⠀⠀⠀⠀⠀⠀^0@@%&^⠀⠀⠀⠀0@@&⠀⠀⠀⠀&@@%^⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀^000000⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀^000%%%%%⠀&@&0o.o0000&&%%@@@@%&0*^'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀^0^⠀⠀⠀⠀⠀⠀⠀⠀''⠀⠀⠀⠀⠀''⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀^0000⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀'00%%%%%⠀^&&%%%%&&&&000*^^'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀^00⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀'0%%%%'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀^''⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      },
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },
    -- stylua: ignore end
    explorer = {
      enabled = true,
    },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    -- words = { enabled = true },
    image = {
      enabled = true,
      -- See: ../lang/markdown/obsidian-nvim.lua
      -- img_dirs = { "90 - System/Assets" },
      math = {
        enabled = true,
        font_size = "small",
      },
    },
    picker = {
      enabled = true,
      ui_select = true,
    },
  },

  keys = {
    {
      "<leader>ba",
      function()
        require("snacks").dashboard()
      end,
      desc = "Toggle Dashboard",
    },
    {
      "<leader>ft",
      function()
        require("snacks").explorer()
      end,
      desc = "Toggle File Tree",
    },
    {
      "<leader>fc",
      function()
        require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Edit Configs",
    },
    {
      "<leader>/",
      function()
        require("snacks").picker.grep()
      end,
      desc = "Grep Files",
    },
    {
      "<leader>;",
      function()
        require("snacks").picker.commands()
      end,
      desc = "Show Commands",
    },
    {
      "<leader>ui",
      function()
        require("snacks").picker.colorschemes()
      end,
      desc = "Change Colorscheme",
    },
    {
      "<leader>pd",
      function()
        require("snacks").picker.zoxide()
      end,
      desc = "List Recent Directories (Zoxide)",
    },
    {
      "<leader>R",
      function()
        require("snacks").picker.resume()
      end,
      desc = "Resume Picker",
    },

    -- 2. Git 操作
    {
      "<leader>gs",
      function()
        require("snacks").picker.git_status()
      end,
      desc = "Git Status",
    },
    {
      "<leader>gt",
      function()
        require("snacks").picker.git_branches()
      end,
      desc = "Git Branches",
    },
    {
      "<leader>gc",
      function()
        require("snacks").picker.git_log()
      end,
      desc = "Git Log (Commits)",
    },

    -- 3. 文件与缓存管理
    {
      "<leader>ff",
      function()
        require("snacks").picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fb",
      function()
        require("snacks").picker.buffers()
      end,
      desc = "List Buffers",
    },
    {
      "<leader>bB",
      function()
        require("snacks").picker.buffers()
      end,
      desc = "List Buffers",
    }, -- 保持你原有的冗余映射
    {
      "<leader>fh",
      function()
        require("snacks").picker.recent()
      end,
      desc = "Recent Files",
    },

    -- 4. 符号与搜索 (LSP/Treesitter 转换)
    -- 原 fzf-lua 的 treesitter 对应 Snacks 的 lsp_symbols 或 treesitter
    {
      "<leader>cs",
      function()
        require("snacks").picker.lsp_symbols()
      end,
      desc = "Search Symbols",
    },
    -- 原 grep_visual 对应 Snacks 的 grep_word (自动识别光标下单词或视觉选区)
    {
      "<leader>cS",
      function()
        require("snacks").picker.grep_word()
      end,
      desc = "Search Current Symbol",
      mode = { "n", "x" },
    },

    -- 5. Snacks 特色/增强 (保留你示例中的高频项)
    {
      "<leader><space>",
      function()
        require("snacks").picker.smart()
      end,
      desc = "Smart Find Files",
    },
    {
      "<leader>e",
      function()
        require("snacks").explorer()
      end,
      desc = "File Explorer",
    },
    {
      "<leader>sd",
      function()
        require("snacks").picker.diagnostics()
      end,
      desc = "Diagnostics",
    },

    -- LSP 跳转 (Picker 增强版)
    {
      "gd",
      function()
        require("snacks").picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "gr",
      function()
        require("snacks").picker.lsp_references()
      end,
      nowait = true,
      desc = "References",
    },
    {
      "gy",
      function()
        require("snacks").picker.lsp_type_definitions()
      end,
      desc = "Goto T[y]pe Definition",
    },
  },
}

-- Previous headers
--
-- stylua: ignore end
--         header = [[
-- =================     ===============     ===============   ========  ========
-- \\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
-- ||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
-- || . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
-- ||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
-- || . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||
-- ||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
-- || . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
-- ||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
-- ||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
-- ||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
-- ||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
-- ||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
-- ||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||
-- ||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||
-- ||.=='    _-'                                                     `' |  /==.||
-- =='    _-'                        N E O V I M                         \/   `==
-- \   _-'                                                                `-_   /
--  `''                                                                      ``'
--         ]],
--[[header = [[
     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣴⣦⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
     ⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀
     ⠀⠀⠀⠀⣠⣾⣿⣿⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣶⡀⠀⠀⠀⠀
     ⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀⣶⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣦⠀⠀⠀
     ⠀⠀⣼⣿⣿⠋⠀⠀⠀⠀⠀⠛⠛⢻⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀
     ⠀⢸⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⡇⠀
     ⠀⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀
     ⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡟⢹⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⣹⣿⣿⠀
     ⠀⣿⣿⣷⠀⠀⠀⠀⠀⠀⣰⣿⣿⠏⠀⠀⢻⣿⣿⡄⠀⠀⠀⠀⠀⠀⣿⣿⡿⠀
     ⠀⢸⣿⣿⡆⠀⠀⠀⠀⣴⣿⡿⠃⠀⠀⠀⠈⢿⣿⣷⣤⣤⡆⠀⠀⣰⣿⣿⠇⠀
     ⠀⠀⢻⣿⣿⣄⠀⠀⠾⠿⠿⠁⠀⠀⠀⠀⠀⠘⣿⣿⡿⠿⠛⠀⣰⣿⣿⡟⠀⠀
     ⠀⠀⠀⠻⣿⣿⣧⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠏⠀⠀⠀
     ⠀⠀⠀⠀⠈⠻⣿⣿⣷⣤⣄⡀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⠟⠁⠀⠀⠀⠀
     ⠀⠀⠀⠀⠀⠀⠈⠛⠿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀
     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
      --]]
