{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (hermes-agent.hermesDesktop.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ makeWrapper ];

      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/hermes-desktop \
          --add-flags "--password-store=gnome-libsecret"
      '';
    }))
  ];
}
