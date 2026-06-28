{
  flake.homeModules.zellij =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      zellij-scrollback-nvim = pkgs.writeShellApplication {
        name = "zellij-scrollback-nvim";
        runtimeInputs = [ config.programs.neovim.package ];
        text = ''
          exec nvim \
            --cmd 'set termguicolors' \
            -S ${zellij-scrollback-nvim-lua} \
            "$@"
        '';
      };
      zellij-scrollback-nvim-lua = pkgs.writeText "zellij-scrollback-nvim.lua" /* lua */ ''
        vim.schedule(function()
        	local path = vim.fn.argv(0)
        	if not path or path == "" then
        		return
        	end

        	local f = assert(io.open(path, "rb"))
        	local data = f:read("*a")
        	f:close()

        	vim.cmd("enew")

        	local buf = vim.api.nvim_get_current_buf()
        	vim.bo[buf].buftype = "nofile"
        	vim.bo[buf].bufhidden = "wipe"
        	vim.bo[buf].swapfile = false
        	vim.bo[buf].modifiable = false
        	vim.bo[buf].filetype = "ansi-scrollback"

        	vim.api.nvim_buf_set_name(buf, "Zellij Scrollback")

        	local chan = vim.api.nvim_open_term(buf, {})
        	vim.api.nvim_chan_send(chan, data)

          vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(buf) then
              vim.api.nvim_set_current_buf(buf)
              vim.cmd("normal! G") -- Move to the end of the buffer
            end
          end, 10)

        	vim.keymap.set("n", "q", "<cmd>qa!<CR>", { buffer = buf })
        end)
      '';
      shell = config.nixdots.apps.interactiveShell.package;
    in
    {
      programs.zellij = {
        enable = true;
        settings = {
          default_shell = lib.getExe shell;
          session_serialization = false;
          scrollback_editor = lib.getExe zellij-scrollback-nvim;
        };
        extraConfig = (builtins.readFile ./zellij.kdl);
      };

      misc.shellAliases = {
        zj = "zellij";
      };
      xdg.configFile."zellij/layouts" = {
        source = ./layouts;
        recursive = true;
      };

      programs.fish.interactiveShellInit = /* fish */ ''
        zellij setup --generate-completion fish | source
      '';
    };
}
