{
  pkgs,
  config,
  secrets,
  ...
}:
{
  nixdots = {
    persist.enable = false;
    user = {
      name = "js0ny";
      shell = pkgs.zsh;
    };
    programs.firefox.enable = true;
    core = {
      hostname = "crystal";
      dots = "${config.nixdots.user.home}/Atelier/dot/nixcfgs";
      flakeDir = "${config.nixdots.user.home}/Atelier/dot/nixdots";
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
    linux = {
      enable = true;
      wsl = true;
      lanzaboote = false;
    };
    machine = {
      role = "standalone";
      compat = false;
      virtualisation = {
        waydroid = false;
        libvirt = {
          enable = false;
        };
        oci-container.podman = false;
      };
    };
    desktop = {
      enable = false;
    };
    keymaps = {
      enable = false;
    };
    sops = {
      enable = true;
      yamlFile = secrets + /secrets.yaml;
      keyFile = "${config.nixdots.user.home}/.config/sops/age/keys.txt";
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
