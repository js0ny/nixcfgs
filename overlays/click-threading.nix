final: prev: {
  python3Packages = prev.python3Packages.overrideScope (
    _: pyPrev: {
      click-threading = pyPrev.click-threading.overridePythonAttrs (_: {
        # Python 3.14 no longer provides pkg_resources, which this package's documentation config imports during pytest collection.
        doCheck = false;
      });
    }
  );
}
