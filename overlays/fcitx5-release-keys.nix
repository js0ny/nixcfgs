final: prev: {
  fcitx5 = prev.fcitx5.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (final.fetchpatch {
        url = "https://github.com/fcitx/fcitx5/pull/1648.patch";
        hash = "sha256-4tezejmxDxPOcJKszSYePCScN2hJidhnhp+E9n8ekRI=";
      })
    ];
  });
}
