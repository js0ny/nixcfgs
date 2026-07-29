{
  flake.nixosModules.cosmic = { pkgs, ... }: {
    services.desktopManager.cosmic.enable = true;
    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-term
      cosmic-wallpapers
      cosmic-reader
      cosmic-player
      networkmanagerapplet
    ];
  };
  flake.homeModules.cosmic = { config, ... }: {
    # This is a minimal config for testing environment for cosmic desktop
    # Aim to not break configs like icon themes,
    # since cosmic will override the global icon theme once log in to cosmic session
    xdg.configFile."cosmic-initial-setup-done".text = "";
    xdg.configFile = {
      "cosmic/com.system76.CosmicTk/v1/icon_theme".text = config.nixdots.style.icon.dark;
      "cosmic/com.system76.CosmicTk/v1/interface_font".text =
        (builtins.head config.nixdots.style.fonts.sansSerif).name;
      "cosmic/com.system76.CosmicTk/v1/monospace_font".text =
        (builtins.head config.nixdots.style.fonts.editorMono).name;
      "cosmic/com.system76.CosmicAppList/v1/favorites".text = /* ron */ ''
        [
            "firefox",
            "kitty",
        ]
      '';
      "cosmic/com.system76.CosmicPanel.Dock/v1/plugins_center".text = /* ron */ ''
        Some([
            "com.system76.CosmicAppList",
            "com.system76.CosmicAppletMinimize",
        ])
      '';
      "cosmic/com.system76.CosmicComp/v1/input_default".text = /* ron */ ''
        (
            state: Enabled,
            acceleration: Some((
                profile: Some(Flat),
                speed: 0.0,
            )),
            left_handed: Some(false),
            scroll_config: Some((
                method: None,
                natural_scroll: Some(false),
                scroll_button: None,
                scroll_factor: None,
            )),
        )
      '';
    };
  };
}
