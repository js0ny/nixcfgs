# nixpkgs#576161: sphinx never writes the man output, so the build fails.
final: prev: {
  khal = prev.khal.overrideAttrs (old: {
    outputs = builtins.filter (output: output != "man") old.outputs;
    sphinxBuilders = builtins.filter (builder: builder != "man") old.sphinxBuilders;
  });
}
