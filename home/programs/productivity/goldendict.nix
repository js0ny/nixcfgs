{pkgs, ...}: {
  home.packages = with pkgs; [
    goldendict-ng
  ];
  home.sessionVariables = {
    GOLDENDICT_FORCE_WAYLAND = 1;
  };
}
