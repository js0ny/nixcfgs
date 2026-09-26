{
  pkgs,
  config,
  secrets,
  ...
}:
{
  js0ny = {
    geo = {
      longitude = -3.2;
      latitude = 55.95;
      city = "Edinburgh";
    };
    apps = {
      interactiveShell = {
        package = pkgs.fish;
        exe = "fish";
        desktop = "";
      };
      editor = {
        tui = {
          package = pkgs.neovim;
          exe = "nvim";
          desktop = "nvim.desktop";
        };
      };
    };
    host = {
      hostName = "crystal";
      timezones = [
        "Europe/London"
        "Etc/UTC"
        "Asia/Shanghai"
      ];
      locales = {
        guiLocale = "zh-CN";
      };
      flakeDir = "${config.js0ny.user.home}/Atelier/dot/nixcfgs";
    };
    desktop.enable = false;
    hardware.laptop.enable = false;
    style = {
      enable = false;
      stylix = {
        enable = false;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
      };
    };
  };
  sops = {
    defaultSopsFile = secrets + "/secrets.yaml";
    age = {
      keyFile = "${config.js0ny.user.home}/.config/sops/age/keys.txt";
      generateKey = false;
    };
    secrets = {
      tskey_crystal = { };
      restic_repo_password = { };
    };
  };
}
