{
  pkgs,
  config,
  secrets,
  ...
}:
{
  js0ny = {
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
  };
  nixdots = {
    persist.enable = false;
    programs.firefox.enable = true;
    core = {
      hostname = "crystal";
      dots = "${config.js0ny.user.home}/Atelier/dot/nixcfgs";
      flakeDir = "${config.js0ny.user.home}/Atelier/dot/nixdots";
      timezones = [
        "Europe/London"
        "Etc/UTC"
        "Asia/Shanghai"
      ];
      locales = {
        guiLocale = "zh-CN";
      };
    };
    services = {
      sshd.enable = true;
    };
    networking.nftables.enable = false;
    style = {
      enable = false;
      stylix = {
        enable = false;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
      };
    };
    laptop.enable = false;
    linux = {
      enable = true;
      wsl = true;
      lanzaboote = false;
    };
    machine = {
      role = "standalone";
    };
    desktop = {
      enable = false;
    };
    sops = {
      enable = true;
      yamlFile = secrets + "/secrets.yaml";
      keyFile = "${config.js0ny.user.home}/.config/sops/age/keys.txt";
      secrets = {
        tskey_crystal = { };
        restic_repo_password = { };
      };
    };
    geo = {
      longitude = -3.2;
      latitude = 55.95;
      city = "Edinburgh";
    };
  };
}
