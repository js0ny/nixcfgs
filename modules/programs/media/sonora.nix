{
  pkgs,
  inputs,
  secrets,
  config,
  ...
}:
let
  sopsFile = secrets + "/creds/musicbrainz.yaml";
in
{
  js0ny.persist.stores.local.directories = [
    ".local/share/sonora"
    ".cache/sonora"
  ];

  home.packages = [
    inputs.sonora.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  sops.secrets = {
    brainz_username = { inherit sopsFile; };
    brainz_token = { inherit sopsFile; };
  };

  sops.templates."sonora-config.json" = {
    content = builtins.toJSON {
      normalisation = false;
      gapless = true;
      equalizer = false;
      equalizer_bands = [
        0
        0
        0
        0
        0
        0
        0
        0
        0
        0
      ];
      sleep_timer = false;
      discord_presence = true;
      discord_name = "sonora";
      discord_show_paused = false;
      discord_badge = false;
      discord_without_details = false;
      discord_sonora_button = true;
      discord_provider_button = true;
      artwork_for_local_files = true;
      lyrics_for_local_files = true;
      prefer_local_lyrics = false;
      local_lyrics_offered = false;
      lyrics_providers = [
        "Apple Music"
        "Local"
        "LrcLib"
        "Musixmatch"
        "NetEase"
        "Spotify"
        "YouTube Music"
      ];
      karaoke_lyrics = true;
      blur_lyrics = true;
      romanized_lyrics = false;
      panel_lyrics_scale = 1;
      fullscreen_lyrics_scale = 1;
      romanization_scripts = {
        japanese = false;
        chinese = false;
        korean = true;
        cyrillic = true;
        greek = false;
        arabic = true;
        other = false;
      };
      adaptive_menu = false;
      check_updates = false;
      close_to_tray = true;
      tray_icon = true;
      stay_awake = true;
      language = "zh-CN";
      font = "LXGW WenKai";
      startup = "home";
      scrobbling = {
        listenbrainz = {
          session = config.sops.placeholder.brainz_token;
          name = config.sops.placeholder.brainz_username;
          enabled = true;
        };
      };
      appearance = {
        theme = "system";
        adaptive_theme = true;
        ambient = true;
        ambient_motion = true;
        visualizer = true;
        visualizer_style = "both";
        visualizer_absolute = false;
        icons = "lucide";
        rounding = "rounded";
        blur = true;
        blur_window = true;
        font_size = 15;
        transparent = true;
        transparency = 0.1;
        server_side_decorations = true;
        window_rounding = "square";
        window_controls = true;
        traffic_light_controls = false;
        controls_on_left = false;
        reduce_motion = "system";
        motion_pace = "base";
        battery_saver = "off";
        theme_overrides = {
          background = null;
          foreground = null;
          border = null;
          muted = null;
          overlay = null;
          overlay_foreground = null;
          muted_foreground = null;
          secondary = null;
          secondary_hover = null;
          secondary_active = null;
          primary = null;
          primary_foreground = null;
          primary_hover = null;
          danger = null;
          danger_foreground = null;
          danger_hover = null;
          popover = null;
          popover_foreground = null;
          progress_bar = null;
          selection = null;
          sidebar = null;
          sidebar_accent = null;
          sidebar_border = null;
          title_bar_border = null;
          table_head = null;
          table_head_foreground = null;
          table_row_border = null;
          table_hover = null;
          table_active = null;
          table_active_border = null;
          radius = null;
          font_size = null;
        };
        fullscreen_controls_autohide = "automatic";
      };
    };
    path = "${config.xdg.configHome}/sonora/config.json";
  };
}
