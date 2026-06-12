{ pkgs, lib, ... }:
let
  hermes-desktop = (
    pkgs.hermes-agent.hermesDesktop.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

      postFixup = (old.postFixup or "") + /* bash */ ''
        wrapProgram $out/bin/hermes-desktop \
          --add-flags "--password-store=gnome-libsecret"
      '';
    })
  );
in
{
  home.packages = [ hermes-desktop ];

  xdg.desktopEntries."com.NousResearch.hermes-agent.hermes-desktop" = {
    name = "Hermes Desktop";
    genericName = "Generic LLM Agent";
    comment = "A desktop application for Hermes";
    exec = lib.getExe hermes-desktop;
    icon = ./icon.png; # extracted from windows binary (MIT)
    terminal = false;
    categories = [ "Utility" ];
  };

  nixdots.persist.nosnap.home.directories = [ ".config/Hermes" ];
}
