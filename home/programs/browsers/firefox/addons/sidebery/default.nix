{
  pkgs,
  config,
  ...
}:
let
  addons = pkgs.firefox-addons;
  id = "{3c078156-979c-498b-8990-85f7987dd929}";
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  imports = [
    ./keymaps.nix
  ];
  programs.firefox.profiles."${p}" = {
    extensions.packages = with addons; [ sidebery ];
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
