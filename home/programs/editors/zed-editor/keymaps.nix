{ ... }:
{
  programs.zed-editor = {
    userKeymaps = [
      {
        context = "Workspace";
        bindings = { };
      }
      {
        context = "Editor";
        bindings = {
          alt-k = "editor::AddSelectionAbove";
          alt-j = "editor::AddSelectionBelow";
        };
      }
      {
        context = "vim_mode == visual || vim_mode == operator";
        bindings = {
          H = "vim::StartOfLine";
          L = "vim::EndOfLine";
        };
      }
      {
        context = "vim_mode == normal";
        bindings = {
          H = "pane::ActivatePreviousItem";
          L = "pane::ActivateNextItem";
          Y = [
            "workspace::SendKeystrokes"
            "y $"
          ];
        };
      }
      {
        context = "Editor && vim_mode == normal && !VimWaiting && !menu";
        bindings = {
          "space space" = "file_finder::Toggle";
          "space ;" = "command_palette::Toggle";
          "space !" = "workspace::NewTerminal";
          "space /" = "pane::DeploySearch";
          "space f c" = "zed::OpenSettings";
          "space f e c" = "zed::OpenSettings";
          "space f t" = "project_panel::ToggleFocus";
          "space c f" = "editor::Format";
          "space b D" = "workspace::CloseInactiveTabsAndPanes";
          "ctrl-w alt-h" = "workspace::ToggleLeftDock";
          "ctrl-w alt-l" = "workspace::ToggleRightDock";
          "ctrl-w alt-j" = "workspace::ToggleBottomDock";
          "[ d" = "editor::GoToPreviousDiagnostic";
          "] d" = "editor::GoToDiagnostic";
          "[ g" = "editor::GoToPreviousHunk";
          "] g" = "editor::GoToHunk";
        };
      }
      {
        context = "vim_mode == normal || vim_mode == visual || vim_mode == operator";
        bindings = {
          j = "vim::Down";
          k = "vim::Up";
          l = "vim::Right";
          n = "search::SelectNextMatch";
          N = "search::SelectPreviousMatch";
          J = [
            "workspace::SendKeystrokes"
            "j j j j j"
          ];
          K = [
            "workspace::SendKeystrokes"
            "k k k k k"
          ];
        };
      }
      {
        context = "ProjectPanel && not_editing";
        bindings = {
          j = "menu::SelectNext";
          k = "menu::SelectPrevious";
          l = "project_panel::ExpandSelectedEntry";
          A = "project_panel::NewDirectory";
          a = "project_panel::NewFile";
          d = "project_panel::Delete";
        };
      }
      {
        context = "Terminal";
        bindings = {
          ctrl-p = [
            "terminal::SendKeystroke"
            "ctrl-p"
          ];
          ctrl-n = [
            "terminal::SendKeystroke"
            "ctrl-n"
          ];
          ctrl-T = "workspace::NewTerminal";
          ctrl-w = null;
          "ctrl-w ctrl-w" = [
            "terminal::SendKeystroke"
            "ctrl-w"
          ];
          "ctrl-w h" = "workspace::ActivatePaneLeft";
          "ctrl-w k" = "workspace::ActivatePaneUp";
          "ctrl-w l" = "workspace::ActivatePaneRight";
          "ctrl-w j" = "workspace::ActivatePaneDown";
        };
      }
      {
        context = "vim_mode == normal || vim_mode == visual";
        bindings = {
          s = "vim::PushSneak";
          shift-s = "vim::PushSneakBackward";
        };
      }
      {
        bindings = {
          "alt-x" = "command_palette::Toggle";
        };
      }
    ];
  };
}
