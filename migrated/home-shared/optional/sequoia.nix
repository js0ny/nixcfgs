{ pkgs, ... }: {
  home.packages = [
    pkgs.sequoia-sq
  ];
  js0ny.persist.stores.state.directories = [
    {
      directory = ".local/share/pgp.cert.d";
      mode = "0700";
    }
    {
      directory = ".local/share/sequoia";
      mode = "0700";
    }
  ];
}
