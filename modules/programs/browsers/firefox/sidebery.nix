# https://github.com/mbnuqw/sidebery/blob/v5.6.1/src/services/settings.ts
# https://github.com/mbnuqw/sidebery/blob/v5.6.1/src/services/styles.fg.ts
# https://github.com/mbnuqw/sidebery/blob/v5.6.1/src/defaults/settings.ts
{
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
}
