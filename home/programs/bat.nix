{ ... }:
{

  programs.bat.enable = true;

  home.sessionVariables = {
    # https://github.com/sharkdp/bat/issues/1433#issuecomment-3298530339
    MANPAGER = ''sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman' '';
  };
}
