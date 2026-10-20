final: prev: {
  pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
    (pythonFinal: pythonPrev: {
      anyio = pythonPrev.anyio.overrideAttrs (oldAttrs: {
        # AnyIO 4.14.2 passes a client-only hostname to the test TLS server.
        patches =
          (oldAttrs.patches or [ ])
          ++ prev.lib.optional (oldAttrs.version == "4.14.2") ./patches/anyio-tls-test.patch;
      });
    })
  ];
}
