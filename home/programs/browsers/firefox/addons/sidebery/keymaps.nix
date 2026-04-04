{config, ...}: let
  id = "{3c078156-979c-498b-8990-85f7987dd929}";
  home = config.nixdots.user.home;
  p = config.nixdots.programs.firefox.defaultProfile;
in {
  mergetools."sidebery-keymaps" = {
    target = "${home}/.mozilla/firefox/${p}/extension-settings.json";
    format = "json";
    settings = {
      commands = {
        "switch_to_panel_0" = {
          "precedenceList" = [
            {
              "id" = id;
              "installDate" = 1000;
              "value" = {"shortcut" = "Ctrl+1";};
              "enabled" = true;
            }
          ];
        };
        "switch_to_panel_1" = {
          "precedenceList" = [
            {
              "id" = id;
              "installDate" = 1000;
              "value" = {"shortcut" = "Ctrl+2";};
              "enabled" = true;
            }
          ];
        };
        "switch_to_panel_2" = {
          "precedenceList" = [
            {
              "id" = id;
              "installDate" = 1000;
              "value" = {"shortcut" = "Ctrl+3";};
              "enabled" = true;
            }
          ];
        };
        "switch_to_panel_3" = {
          "precedenceList" = [
            {
              "id" = id;
              "installDate" = 1000;
              "value" = {"shortcut" = "Ctrl+4";};
              "enabled" = true;
            }
          ];
        };
        "next_panel" = {
          "precedenceList" = [
            {
              "id" = id;
              "installDate" = 1000;
              "value" = {"shortcut" = "";};
              "enabled" = true;
            }
          ];
        };
        "prev_panel" = {
          "precedenceList" = [
            {
              "id" = id;
              "installDate" = 1000;
              "value" = {"shortcut" = "";};
              "enabled" = true;
            }
          ];
        };
        "switch_to_prev_tab" = {
          "precedenceList" = [
            {
              "id" = id;
              "installDate" = 1000;
              "value" = {"shortcut" = "Alt+H";};
              "enabled" = true;
            }
          ];
        };
        "switch_to_next_tab" = {
          "precedenceList" = [
            {
              "id" = id;
              "installDate" = 1000;
              "value" = {"shortcut" = "Alt+L";};
              "enabled" = true;
            }
          ];
        };
      };
    };
  };
}
