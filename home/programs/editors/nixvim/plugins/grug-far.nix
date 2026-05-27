{ ... }:
{
  programs.nixvim = {
    plugins.grug-far = {
      enable = true;
    };
    # keymaps = [
    #   {
    #     key = "<leader>fF";
    #     action.__raw = ''
    #       function()
    #         local grug = require("grug-far")
    #         local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
    #         grug.open({
    #           transient = true,
    #           prefills = {
    #             filesFilter = ext and ext ~= "" and "*." .. ext or nil,
    #           },
    #         })
    #       end,
    #     '';
    #     mode = [
    #       "n"
    #       "v"
    #     ];
    #     options.desc = "Search and Replace";
    #   }
    # ];
  };
}
