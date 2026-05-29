{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages =
        let
          flattenPackages =
            prefix: attrs:
            pkgs.lib.concatMapAttrs (
              name: value:
              let
                packageName = if prefix == "" then name else "${prefix}-${name}";
              in
              if pkgs.lib.isDerivation value then
                { ${packageName} = value; }
              else if pkgs.lib.isAttrs value then
                flattenPackages packageName value
              else
                { }
            ) attrs;
        in
        flattenPackages "" (
          import ../pkgs {
            inherit pkgs;
            lib = pkgs.lib;
          }
        );
    };

}
