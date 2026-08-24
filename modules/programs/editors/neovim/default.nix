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
          # keep-sorted start block=yes
          basedpyright.enable = true;
          bashls.enable = true;
          clangd.enable = true;
          fish_lsp.enable = true;
          gopls.enable = true;
          jsonls.enable = true;
          roslyn_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          svelte.enable = true;
          taplo.enable = true;
          vtsls.enable = true;
          # keep-sorted end
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
