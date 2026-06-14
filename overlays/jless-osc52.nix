final: prev: {
  jless = prev.jless.overrideAttrs (
    finalAttrs: oldAttrs: {
      src = final.fetchFromGitHub {
        owner = "guox18";
        repo = "jless";
        rev = "49d6024eed0eb0d95f0c20b0d12886cc2846c5a4";
        hash = "sha256-7QJF09VMBs3p6wjT2RccoxyUiTSE1T90wdvg5LVNK0o=";
      };

      cargoDeps = final.rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) src;
        hash = "sha256-OowQ8jbpEGvcScgTWMyeLGLfvpxNu1oLEbRjUOv5xKU=";
      };
    }
  );
}
