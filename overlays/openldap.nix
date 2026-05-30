# Upstream: https://github.com/NixOS/nixpkgs/pull/525133
_: prev: {
  openldap = prev.openldap.overrideAttrs {
    doCheck = !prev.stdenv.hostPlatform.isi686;
  };
}
