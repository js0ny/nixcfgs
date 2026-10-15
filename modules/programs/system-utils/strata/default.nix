{
  flake.homeModules.strata =
    {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }:
    let
      settingsFormat = pkgs.formats.toml { };
      # https://github.com/lgse/strata/blob/v1.0.0/src/settings.rs
      settings = {
        mode = "theme";
        theme = "catppuccin-mocha";
        omarchy_variant = "original";
        folder_peeking = true;
        single_click_previews = true;
        columns_mirror_selection = true;
        columns_show_sizes = true;
        render_documents_by_default = true;
        video_preview_backend = "automatic";
        search_open_files_directly = false;
        search_exclusions = [ "result" ];
        type_to_search = true;
        arrow_navigation_scoped = false;
        tenxer_mode = true;
        filter_include_subfolders = true;
        show_keybinding_hints = false;
        window_show_close = true;
        window_show_minimize = false;
        window_show_maximize = false;
        reduce_motion = false;
        element_glow = true;
        file_icon_colors = "brand";
        browser_mode = "columns";
        browser_density = "compact";
        group_by_type = false;
        list_file_clicks = 2;
        list_folder_clicks = 1;
        grid_file_clicks = 2;
        grid_folder_clicks = 2;
        explorer_file_clicks = 2;
        explorer_folder_clicks = 2;
        sidebar_order = [
          "home"
          "recent"
          "trash"
          "network"
          "desktop"
          "documents"
          "downloads"
          "music"
          "pictures"
          "videos"
        ];
        sidebar_show_home = true;
        sidebar_show_trash = true;
        sidebar_show_network = false;
        sidebar_show_recent = true;
        sidebar_show_desktop = false;
        sidebar_show_documents = true;
        sidebar_show_downloads = true;
        sidebar_show_music = false;
        sidebar_show_pictures = false;
        sidebar_show_videos = false;
        sidebar_expanded = true;
        show_hidden = true;
        text_size = 13;
        interface_renderer = "system";
        language = "zh-CN";
        folders_first = true;
        sort_key = "name";
        sort_direction = "ascending";
        check_for_updates = false;
        preview_muted = false;
        preview_volume = 1.0;
        preview_text_wrap = false;
        preview_autoplay = false;
        auto_refresh_interval = 0;
        thumbnail_workers = 4;
        icons_thumbnail_size = 64;
        cross_volume_drop_strategy = "always-ask";
        open_folder_after_drop = false;
        date_format = "relative";
        release_channel = "stable";
        restore_tabs = true;
        remember_folder_views = true;
      };
    in
    {
      home.packages = [ inputs.strata.packages.${pkgs.stdenv.hostPlatform.system}.strata ];

      xdg.configFile."strata/settings.toml" = {
        source = settingsFormat.generate "strata-settings.toml" settings;
        force = true;
      };

      # Strata rewrites its preferences, so keep the deployed file writable.
      makeMutable = [
        "${lib.removePrefix "${config.home.homeDirectory}/" config.xdg.configHome}/strata/settings.toml"
      ];
    };
}
