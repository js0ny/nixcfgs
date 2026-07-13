final: prev: {
  gdalMinimal = prev.gdalMinimal.overrideAttrs {
    doInstallCheck = false;
  };
}
