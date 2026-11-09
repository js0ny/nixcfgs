{ ... }: {
  services.postgresql.enable = true;

  js0ny.persist.stores.state.directories = [ "/var/lib/postgresql" ];
}
