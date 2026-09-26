{
  environment.sessionVariables = {
    # Default value: FRSXMK, where S indicates "Chops long lines"
    SYSTEMD_LESS = "FRXMK";
  };

  # systemd aliases
  environment.shellAliases = {
    sc = "systemctl";
    scc = "systemctl cat";
    scs = "systemctl status";
    jc = "journalctl";
    jcx = "journalctl -xeu";
  };

}
