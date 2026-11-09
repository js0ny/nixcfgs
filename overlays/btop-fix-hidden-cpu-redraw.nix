final: prev: {
  btop = prev.btop.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (final.fetchpatch {
        name = "btop-fix-hidden-cpu-redraw.patch";
        url = "https://github.com/aristocratos/btop/commit/a87dd16e78a862b6a2c4ea0206317d958cdf41de.patch";
        hash = "sha256-SJdj1Mb09wxopenXPVSmdS9fAUOw+3bzB6cnZbQ2nRA=";
      })
    ];
  });
}
