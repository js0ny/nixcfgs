{config, ...}: let
  user = config.home.username;
in {
  targets.darwin.defaults."com.raycast.macos" = {
    onboardingCompleted = 1;
    "onboarding_setupAlias" = 1;
    "onboarding_setupHotkey" = 1;
    "onboarding_showTasksProgress" = 1;
    "permissions.folders.read:/Users/${user}/Desktop" = 1;
    "permissions.folders.read:/Users/${user}/Documents" = 1;
    "permissions.folders.read:/Users/${user}/Downloads" = 1;
    raycastAiHasSeenQuickAI = 1;
    # Hotkey to trigger Raycast:  CMD+SPC
    raycastGlobalHotkey = "Command-49";
    # Text Size: "medium" | "large"
    "raycastUI_preferredTextSize" = "medium";
    # Window Mode: "default" | "compat"
    raycastPreferredWindowMode = "compat";
    # Theme: Use Default
    raycastShouldFollowSystemAppearance = 1;
    raycastCurrentThemeIdDarkAppearance = "bundled-raycast-dark";
    raycastCurrentThemeIdLightAppearance = "bundled-raycast-light";
    # Show Raycast Item in menu bar icon
    "NSStatusItem VisibleCC raycastIcon" = 1;
    # Show Raycast on:
    # * 0: Screen containing mouse
    # * 1: Screen with active window
    # * 2: Primary screen
    raycastWindowPresentationMode = 0;
    # Timeout after which Raycast will reset to root search after closing the window
    # 0 | 5 | 15 | 30 | 60 | 90 (*) | 120 | 180
    popToRootTimeout = 90;
    # Escape Key Behavior:
    # * 0: Navigate back or close window
    # * 1: Close window and pop to root
    raycastWindowEscapeKeyBehavior = 1;
    enforcedInputSourceIDOnOpen = "im.rime.inputmethod.Squirrel";
    # Navigation Bindings:
    # * macos: Emacs F/B/N/P
    # * vim: H/J/K/L
    navigationCommandStyleIdentifierKey = "macos";
    # Page Navigation Keys:
    # * squareBrackets | arrows
    pageNavigationCommandKeysIdentifierKey = "squareBrackets";
    # Root Search Sensitivity: Matching number, low will produce the most results
    # * high | medium | low
    rootSearchSensitivity = "low";
    useHyperKeyIcon = 0;
    "raycast_hyperKey_state" = {
      enabled = 1;
      includeShiftKey = 0;
      keyCode = 231;
    };
    faviconProvider = "raycast";
    "emojiPicker_skinTone" = "standard";
  };
}
