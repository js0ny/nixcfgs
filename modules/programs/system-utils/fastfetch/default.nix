{
  flake.homeModules.fastfetch =
    { pkgs, config, ... }:
    let
      isHeadless = config.nixdots.linux.display == "none";
      customFastfetch = pkgs.fastfetch.override {
        x11Support = false;
        sqliteSupport = true;

        audioSupport = !isHeadless;
        brightnessSupport = !isHeadless;
        dbusSupport = !isHeadless;
        terminalSupport = !isHeadless;
        enlightenmentSupport = false;
        gnomeSupport = false;
        xfceSupport = false;
        openclSupport = !isHeadless;
        openglSupport = !isHeadless;
        vulkanSupport = !isHeadless;
        waylandSupport = !isHeadless;
        imageSupport = !isHeadless;
      };
    in
    {
      programs.fastfetch = {
        enable = true;
        package = customFastfetch;
        # Stolen from: https://codeberg.org/JellyCat/JellyDotFiles/src/branch/main/items/fastfetch/src/config.jsonc
        # https://gitlab.com/CarterLi/fastfetch/-/wikis/Json-Schema
        settings = {
          "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
          logo = {
            source = "NixOS_old_small";
            padding = {
              top = 5;
              left = 2;
            };
          };
          display = {
            separator = " ";
          };
          modules = [
            {
              key = "╭───────────╮";
              type = "custom";
            }
            {
              key = "│ {#31} user    {#keys}│";
              type = "title";
              format = "{user-name}";
            }
            {
              key = "│ {#32}󰇅 host    {#keys}│";
              type = "title";
              format = "{host-name}";
            }
            {
              key = "│ {#34}󰅐 uptime  {#keys}│";
              type = "uptime";
            }
            {
              key = "│ {#34}{icon} distro  {#keys}│";
              type = "os";
            }
            {
              key = "│ {#35} kernel  {#keys}│";
              type = "kernel";
            }
            {
              key = "│ {#36} wm      {#keys}│";
              type = "wm";
            }
            {
              key = "│ {#36}󰇄 desktop {#keys}│";
              type = "de";
            }
            {
              key = "│ {#31} term    {#keys}│";
              type = "terminal";
            }
            {
              key = "│ {#32} shell   {#keys}│";
              type = "shell";
            }
            {
              key = "│ {#33}󰍛 cpu     {#keys}│";
              type = "cpu";
              showPeCoreCount = true;
            }
            {
              key = "│ {#34}󰢮 gpu     {#keys}│";
              type = "gpu";
            }
            {
              key = "│ {#34}󰉉 disk    {#keys}│";
              type = "disk";
              folders = "/";
            }
            {
              key = "│ {#36} ram     {#keys}│";
              type = "memory";
            }
            {
              key = "├───────────┤";
              type = "custom";
            }
            {
              key = "│ {#39} colors  {#keys}│";
              type = "colors";
              symbol = "circle";
            }
            {
              key = "╰───────────╯";
              type = "custom";
            }
          ];
        };
      };
    };
}
