{
  flake.homeModules.neovim =
    {
      pkgs,
      config,
      inputs,
      lib,
      ...
    }:
    let
      nvimAlias = {
        "v" = "nvim";
        "g" = "nvim +Neogit";
      };
      snippets = (import ../lsp-snippets/lib.nix { inherit pkgs config; }).out;
      appname = "nvim";
      flakeRoot = config.nixdots.core.flakeDir;
    in
    {
      programs.neovim.enable = lib.mkForce false;

      imports = [ inputs.nvimdots.homeModules.default ];

      programs.nixvim = {
        enable = true;
        plugins.lsp.servers = {
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          gopls.enable = true;
          ts_ls.enable = true;
          svelte.enable = true;
        };
        keymaps = [
          {
            key = "<leader>fc";
            action.__raw = /* lua */ ''
              function() require('snacks').picker.files({ cwd = "${flakeRoot}" }) end
            '';
            options.desc = "Edit config";
          }
        ];
      };

      stylix.targets.nixvim.enable = false;

      # home.packages = with pkgs; [lua-language-server];
      misc.shellAliases = nvimAlias;

      xdg.configFile."lsp-snippets".source = snippets;

      nixdots.persist.nosnap.home = {
        directories = [
          # nvim(lazy) will download plugins to this dir
          ".local/share/${appname}"
          ".local/state/${appname}"
        ];
      };

      programs.git = {
        settings = {
          merge.tool = "codediff";
          mergetool.codediff = {
            cmd = ''nvim "$MERGED" -c "CodeDiff merge \"$MERGED\""'';
          };
        };
      };
    };
}
