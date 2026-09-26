{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.sops ];

  js0ny.persist.stores.state.directories = [
    ".config/age"
    ".config/sops/age"
  ];
}
