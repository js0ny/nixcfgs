{ ... }:
{

  programs.bat.enable = true;

  home.sessionVariables = {
    MANPAGER = "bat -l man -p";
  };
}
