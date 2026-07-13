final: prev: {
  python314Packages = prev.python314Packages.overrideScope (
    pyFinal: pyPrev: {
      patool = pyPrev.patool.override {
        file = prev.file.overrideAttrs (old: {
          # PR: https://github.com/NixOS/nixpkgs/pull/540742
          postPatch = (old.postPatch or "") + ''
            substituteInPlace src/landlock.c --replace-fail \
              "LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_READ_DIR" \
              "LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_READ_DIR | LANDLOCK_ACCESS_FS_EXECUTE"
          '';
        });
      };
    }
  );
}
