final: prev: {
  aw-qt = prev.aw-qt.overrideAttrs (_: {
    makeWrapperArgs = [
      "--suffix"
      "PATH"
      ":"
      "${prev.lib.makeBinPath [ prev.xdg-utils ]}"
    ];
  });

  pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
    (pythonFinal: pythonPrev: {
      aw-core = pythonPrev.aw-core.override {
        peewee = pythonPrev.peewee_3;
      };
    })
  ];
}
