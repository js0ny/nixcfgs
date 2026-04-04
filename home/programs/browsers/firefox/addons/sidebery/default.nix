{
  pkgs,
  config,
  ...
}: let
  addons = pkgs.firefox-addons;
  id = "{3c078156-979c-498b-8990-85f7987dd929}";
  p = config.nixdots.programs.firefox.defaultProfile;
in {
  programs.firefox.profiles."${p}" = {
    extensions.packages = with addons; [sidebery];
    userChrome = ''
      /*
      Sidebery Friendly Minimalist Style
      */
      :root {
        --tab-min-height: 30px !important;
        --toolbarbutton-inner-padding: 6px !important;
      }
      #TabsToolbar {
        visibility: collapse !important;
      }

      #sidebar-header { display: none; }
      #sidebar-box {
          padding: 0 !important;
      }

      /* disable: <div class="buttons-wrapper"> */
      .buttons-wrapper {
          display: none !important;
      }

      #sidebar-button {
          display: none !important;
      }

      #sidebar-panel-header {
          display: none !important;
      }

    '';
    extensionStorage."${id}".settings = {
      sidebarCSS = builtins.readFile ./sidebery.css;
      settings = {
        ### General
        nativeScrollbars = true;
        nativeScrollbarsThin = true;
        nativeScrollbarsLeft = false;
        updateSidebarTitle = false;
        ### Context Menu
        ctxMenuNative = false;
        ctxMenuRenderInact = true;
        ctxMenuRenderIcons = true;
        ### Omnibox / Address Bar
        omniReopenInCtr = false;
        omniReopenInCtrPrefix = "";
        omniSwitchToPanel = true;
        omniSwitchToPanelPrefix = "=";
        omniMoveToPanel = false;
        omniMoveToPanelPrefix = "";
        omniMoveToGroup = true;
        omniMoveToGroupPrefix = "+";
        ### Navigation bar
        # Layout: "horizontal", "vertical", "hidden"
        navBarLayout = "horizontal";
        # Show navigation bar in one line
        navBarInline = true;
        # Side: "left", "right"; available only if navBarLayout is "vertical"
        navBarSide = "left";
        navBtnCount = true;
        hideEmptyPanels = false;
        hideDiscardedTabPanels = false;
      };
    };
  };
}
