{
  lib,
  rustPlatform,
  pkg-config,
  systemd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "coredump-notify";
  version = "0.1.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./Cargo.toml
      ./Cargo.lock
      ./LICENSE
      ./src
    ];
  };

  cargoLock.lockFile = ./Cargo.lock;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemd ];

  meta = {
    description = "Desktop notifications for systemd coredumps";
    homepage = "https://github.com/js0ny/coredump-notify";
    license = lib.licenses.gpl3Plus;
    mainProgram = "coredump-notify";
    platforms = lib.platforms.linux;
  };
})
