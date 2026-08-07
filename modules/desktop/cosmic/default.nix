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
  flake.homeModules.cosmic = _: {
    imports = [ ./styles.nix ];
    # This is a minimal config for testing environment for cosmic desktop
    # Aim to not break configs like icon themes,
    # since cosmic will override the global icon theme once log in to cosmic session
    xdg.configFile."cosmic-initial-setup-done".text = "";
    xdg.configFile = {
      "cosmic/com.system76.CosmicAppList/v1/favorites".text = /* ron */ ''
        [
            "firefox",
            "kitty",
        ]
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
      "cosmic/com.system76.CosmicIdle/v1/screen_off_time".text = "None";
      "cosmic/com.system76.CosmicIdle/v1/suspend_on_ac_time".text = "None";
      "cosmic/com.system76.CosmicSettings.Shortcuts/v1/system_actions".text = /* ron */ ''
        {
            Terminal: "kitty",
        }
      '';
      "cosmic/com.system76.CosmicAppletTime/v1/show_seconds".text = "true";
    };
  };
}
