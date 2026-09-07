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
      imageSupport = config.programs.kitty.enable || config.programs.ghostty.enable;
    in
    {
      programs.neovim.enable = lib.mkForce false;

      imports = [ inputs.nvimdots.homeModules.default ];

      programs.nixvim = {
        enable = true;
        js0ny = {
          image.enable = imageSupport;
          typst.enable = true;
        };
        plugins = {
          lsp.servers = {
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
          orgmode.settings = {
            org_agenda_files = "~/org/tasks/**/*";
            org_default_notes_file = "~/org/tasks/inbox.org";
          };
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

      js0ny.persist.stores.local.directories = [
        ".local/share/${appname}"
        ".local/state/${appname}"
      ];

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
