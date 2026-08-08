{
  flake.nixosModules.yazi = _: {
    programs.yazi = {
      enable = true;
    };
  };
  flake.homeModules.yazi =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        ./mediainfo.nix
        ./piper.nix
        ./keymaps.nix
      ];
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        shellWrapperName = "y";
        plugins = {
          git = pkgs.yaziPlugins.git;
          starship = pkgs.yaziPlugins.starship;
          mediainfo = pkgs.yaziPlugins.mediainfo;
          ouch = pkgs.yaziPlugins.ouch;
          bookmarks = pkgs.yaziPlugins.bookmarks;
          clipboard = pkgs.yaziPlugins.clipboard;
          dump-tabs = pkgs.js0ny.yaziPlugins.dump-tabs;
          piper = pkgs.yaziPlugins.piper;
        };
        settings = {
          preview.wrap = "yes";
          mgr = {
            show_hidden = true;
            linemode = "size_and_mtime";
          };
          plugin = {
            prepend_fetchers = [
              {
                group = "git";
                url = "*";
                run = "git";
              }
              {
                group = "git";
                url = "*/";
                run = "git";
              }
            ];
            prepend_previewers = [
              {
                mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
                run = "ouch --show-file-icons";
              }
            ];
          };
        };

        initLua = builtins.readFile ./init.lua;
      };
      home.packages = with pkgs; [
        (ouch.override { enableUnfree = pkgs.stdenv.isLinux; })
      ];

      nixdots.persist.nosnap.home.files = [
        # Persist bookmarks
        ".local/state/yazi/.dds"
      ];

    };
  flake.nixosModules.core = { inputs, ... }: {
    imports = [ inputs.self.nixosModules.yazi ];
  };
  flake.homeModules.core = { inputs, ... }: {
    imports = [ inputs.self.homeModules.yazi ];
  };
}
