{ pkgs }:
let
  out =
    name: actionCmd:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = with pkgs; [
        fzf
        fd
        xdg-utils
      ];
      text = ''
        _file=$(fd --type f --exclude '*.lock' | fzf --height 40% --reverse -1 -q "''${1:-}")

        if [ -n "$_file" ]; then
            ${actionCmd} "$_file"
        else
            echo "No file selected."
        fi
      '';
    };
in
{
  inherit out;
}
