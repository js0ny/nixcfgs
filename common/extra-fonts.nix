{ pkgs, ... }: {
  nixdots.style.fonts.extraFonts = [
    {
      package = pkgs.vollkorn;
      name = "Vollkorn";
    }
    {
      package = pkgs.font-awesome;
      name = "Font Awesome 6 Free";
    }
    {
      package = pkgs.ubuntu-sans;
      name = "Ubuntu Sans";
    }
    {
      package = pkgs.nerd-fonts.fira-code;
      name = "Fira Code Nerd Font";
    }
    {
      package = pkgs.cinzel;
      name = "Cinzel";
    }
    {
      package = pkgs.jigmo;
      name = "Jigmo";
    }
  ];
}
