{
  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    extraConfig = ''
      Defaults lecture = never
    '';
  };
}
