_:
let
  posixFx = /* bash */ ''
    mt() {
      mkdir -p "$(dirname "$1")" && touch "$1"
    }
    mtv() {
      mkdir -p "$(dirname "$1")" && touch "$1" && $EDITOR "$1"
    }
  '';

  fishFx = /* fish */ ''
    function mt
        mkdir -p (dirname $argv[1]) && touch $argv[1]
    end

    function mtv
        mkdir -p (dirname $argv[1]) && touch $argv[1] && $EDITOR $argv[1]
    end
  '';
in
{
  inherit posixFx fishFx;
}
