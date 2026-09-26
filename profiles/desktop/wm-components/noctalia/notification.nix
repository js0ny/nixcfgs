{
  programs.noctalia.settings.notification = {
    filter_order = [
      "niri-screenshot"
      "element-ignore-my-msg"
    ];
    filter = {
      niri-screenshot = {
        allow_permanent = true;
        bypass_dnd = true;
        enabled = true;
        match = "niri";
        match_content = "Screenshot captured";
        override_duration = 500; # ms
        play_sound = true;
        save_history = true;
        show_toast = true;
      };
      element-ignore-my-msg = {
        allow_permanent = true;
        bypass_dnd = false;
        enabled = true;
        match = "element";
        match_content = "^js0ny.*$";
        play_sound = false;
        save_history = true;
        show_toast = false;
      };
    };
  };
}
