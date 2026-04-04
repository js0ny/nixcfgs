{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    onlyoffice-desktopeditors
    corefonts
  ];

  # Onlyoffice does not support fontconfig and does not support fonts with symlinks, so we need to copy the system fonts to the user's local share directory. This is a workaround for the issue that Onlyoffice cannot find the system fonts when running in a sandboxed environment.
  # See: https://github.com/NixOS/nixpkgs/issues/373521
  home.activation.onlyoffice-copy-fonts-to-local-share = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # 仅在用户的本地字体目录不存在时才复制系统字体，以避免不必要的复制和权限问题
    if [ ! -d ${config.home.homeDirectory}/.local/share/fonts ]; then
      rm -rf ~/.local/share/fonts
      cp /usr/share/fonts ~/.local/share/fonts -r --dereference
      chmod 544 ~/.local/share/fonts
      chmod 444 ~/.local/share/fonts/*
    fi
  '';
}
