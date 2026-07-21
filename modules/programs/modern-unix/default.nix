{
  flake.nixosModules.modern-unix = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      duf
      dust
      ripgrep
      fd
      curlie
      rip2
      procs
    ];
    programs.htop.enable = true;
  };
  flake.nixosModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.nixosModules.modern-unix ];
  };
  flake.homeModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.homeModules.modern-unix ];
  };
  flake.homeModules.modern-unix =
    { pkgs, config, ... }:
    {
      xdg.configFile."bat/syntaxes/nushell.sublime-syntax".source = ./nushell.sublime-syntax;
      xdg.configFile."bat/syntaxes/fennel.sublime-syntax".source = ./fennel.sublime-syntax;
      imports = [ ./zoxide.nix ];
      misc.shellAliases = {
        ls = "lsd";
        ll = "lsd -l";
        la = "lsd -a";
        lt = "lsd --tree";
      };
      nixdots.persist = {
        home.directories = [
          ".local/share/atuin"
        ];
        nosnap.home.directories = [ ".cache/tealdeer" ];

      };
      home.sessionVariables = {
        MANPAGER = ''sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman' '';
        NIX_PAGER = "bat --style grid,numbers --wrap auto";
      };
      home.packages = with pkgs.localPkgs.fzfScripts; [
        edit-fzf
        ii-fzf
      ];
      misc.shellAliases = {
        "ef" = "edit-fzf";
      };
      programs = {
        bat.enable = true;
        lsd = {
          enable = true;
          icons = "always";
          enableBashIntegration = false;
          enableZshIntegration = false;
          enableFishIntegration = false;
        };
        eza = {
          enable = true;
          colors = "always";
          icons = "always";
          enableBashIntegration = false;
          enableZshIntegration = false;
          enableFishIntegration = false;
        };

        fzf = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          enableFishIntegration = true;
        };

        tealdeer = {
          enable = true;
          enableAutoUpdates = true;
        };
        btop = {
          enable = true;
          settings = {
            vim_keys = true;
          };
          package = pkgs.btop.override {
            cudaSupport = config.nixdots.linux.gpu == "nvidia";
          };
        };
        ripgrep = {
          enable = true;
          # https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
          arguments = [
            "--follow" # follow symlinks
          ];
        };
        htop = {
          enable = true;
          settings = {
            hide_kernel_threads = true;
            hide_userland_threads = true;
            hide_running_in_container = false;
            shadow_other_users = true;
            show_thread_names = true;
            show_program_path = true;
            highlight_base_name = true;
            highlight_deleted_exe = true;
            shadow_distribution_path_prefix = true;
            highlight_megabytes = true;
            highlight_threads = true;
            highlight_changes = true;
            highlight_changes_delay_secs = 5;
            find_comm_in_cmdline = true;
            strip_exe_from_cmdline = true;
            enable_mouse = true;
            tree_view = true;
          };
        };
      };
    };
}
