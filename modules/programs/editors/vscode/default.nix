{
  # This setup only focus on web / frontend and python (propietary python lsp)
  flake.homeModules.vscode =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      codeReleasesConfigDir = [
        "Code"
      ];
      snippets = (import ../lsp-snippets/lib.nix { inherit pkgs config; }).raw;
      dots = config.nixdots.core.dots;
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      programs.vscode = {
        enable = true;
        package = (
          pkgs.vscode.override {
            commandLineArgs = "--password-store=gnome-libsecret";
          }
        );
      };

      programs.vscode.profiles.default = {
        extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
          pkief.material-icon-theme
          vscodevim.vim
          vspacecode.vspacecode
          vspacecode.whichkey
          christian-kohler.path-intellisense
          orangex4.hsnips
          # language support
          jnoortheen.nix-ide
          svelte.svelte-vscode
          bradlc.vscode-tailwindcss
          esbenp.prettier-vscode
          dbaeumer.vscode-eslint
          christian-kohler.npm-intellisense
          tamasfe.even-better-toml
          atomicspirit.nix-embedded-highlighter
          mohsen1.prettify-json
          redhat.vscode-yaml
          redhat.vscode-xml
          ## python
          ms-python.python
          ms-python.debugpy
          ms-python.vscode-python-envs
          njpwerner.autodocstring
          charliermarsh.ruff
          astral-sh.ty

          # misc
          openai.chatgpt # coex
        ];
        userSettings = {
          "workbench.iconTheme" = "material-icon-theme";
          "workbench.colorTheme" = "Stylix";

          # telemetry
          "telemetry.telemetryLevel" = "off";
          "telemetry.feedback.enabled" = false;
          "telemetry.editStats.enabled" = false;

          # vim
          "editor.lineNumbers" = "relative";
          "vim.vimrc.enable" = true;
          "vim.vimrc.path" = ./vscode.vim;
          "vim.hlsearch" = true;
          "vim.useSystemClipboard" = true;
          "vim.smartRelativeLine" = true;
          "vim.useCtrlKeys" = false;
          "vim.camelCaseMotion.enable" = true;

          # hsnips
          "hsnips.linux" = ./hsnips;
          "hsnips.mac" = ./hsnips;

          # nix
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = lib.getExe pkgs.nixd;
          "nix.serverSettings".nixd = config.nixdefs.lsp.servers.nixd.serverSettings;

          # svelte
          "svelte.enable-ts-plugin" = true;

          # misc
          "redhat.telemetry.enabled" = false;
          "editor.formatOnSave" = true;
          "update.showReleaseNotes" = false;
        }
        // lib.optionalAttrs (pkgs.stdenv.isLinux) {
          "window.menuBarVisibility" = "hidden"; # hidden: disable when hit <Alt>
          "window.titleBarStyle" = "native"; # works better on bare WMs
          "vim.autoSwitchInputMethod.defaultIM" = "true";
          "vim.autoSwitchInputMethod.obtainIMCmd" =
            "${lib.getExe pkgs.js0ny.limes} --backend fcitx5-rime --mode ascii";
          "vim.autoSwitchInputMethod.switchIMCmd" =
            "${lib.getExe pkgs.js0ny.limes} --backend fcitx5-rime --mode ascii set {im}";
          "workbench.browser.showInTitleBar" = false;
          "window.commandCenter" = false;
          "chat.titleBar.signIn.enabled" = false;
          "workbench.layoutControl.enabled" = false;
        };
      };

      # Remove default snippet dir before running this to avoid conflicts
      # Textmate snippets
      xdg.configFile =
        builtins.listToAttrs (
          map (dir: {
            name = "${dir}/User/snippets";
            value = {
              source = snippets;
              force = true;
              # recursive = true;
            };
          }) codeReleasesConfigDir
        )
        // {
          "Code/User/keybindings.json".source =
            mkSymlink "${dots}/modules/programs/editors/vscode/keybindings-linux-win.jsonc";
        };

      catppuccin.vscode.profiles.default.enable = false;
      makeMutable = [ ".config/Code/User/settings.json" ];
    };
}
