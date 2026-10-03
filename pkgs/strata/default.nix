# Strata: the Qwen3.8-Flash-Next engine (CUDA), built from source.
#
# Upstream's checkout and the llama.cpp commit its build and tools pin are fetched at fixed revisions. The
# engine is compiled here for this PC's GPU; everything else upstream's setup.py does - the PC checks, the model
# download, the pack build, the run config - is reused as it is: $out/share/strata holds the whole source,
# support and engine tree, setup.py is patched (setup-patch.py) so that the engine and the Python packages are
# Nix's, and the wrappers drive it:
#
#   strata-setup    upstream's setup across a mutable root (STRATA_ROOT, default the current directory)
#   strata-server   upstream's HTTP server
#   strata          the engine itself
#
# The NixOS module that runs them is modules/nixos/services/strata/default.nix.
{
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
  addDriverRunpath,
  writeText,
  cudaPackages_13,
}:

let
  version = "0.1.38";

  # pkgs/strata builds for these GPUs only: one CUDA architecture (Ada, the RTX 40 series and the RTX 4070 Ti
  # SUPER) and the portable AVX2 CPU baseline.
  cudaArch = "89";

  strataSrc = fetchFromGitHub {
    owner = "Niko1221";
    repo = "Strata";
    rev = "99f3dbd0b21d1401b3769e0c0d963913607f380b";
    hash = "sha256-9tawklXlF98yolRTVgeonVcyrob8HiNG3xSQ7V5v+94=";
  };

  # The commit CMakeLists.txt pins for ggml (STRATA_GGML_DIR) and setup.py for gguf-py.
  llamaCpp = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    rev = "3cf03257f219afbe7334045ff7c6a06ac68c627d";
    hash = "sha256-SRGoXa+4ACBCB3eaG9XFYhMN1i0FyPEy9Rrer+dFGYI=";
  };

  # CUDA 13 (upstream's own release engine is built with 13.0; the 595 driver runs it). The set, not a pinned
  # 13.0: nixpkgs keeps its versioned sets' supported compilers in step with the stdenv.
  cudaPackages = cudaPackages_13;

  # What setup.py, serve/server.py and the model tools import (requirements.txt, less cmake/ninja: nothing is
  # built or installed here). gguf-py comes from third_party/llama.cpp.
  python = python3.withPackages (ps: [
    ps.numpy
    ps.jinja2
    ps.regex
    ps.psutil
    ps.pillow
    ps.jsonschema
    ps.referencing
    ps.pyyaml
  ]);

  # The CUDA directories the loader needs at run time (see cuda_dirs below, which serve/server.py also puts on
  # the engine's LD_LIBRARY_PATH). CMake links against the dev outputs - the namelinks - so the shared objects
  # themselves have to be named here, not left to the build's own RUNPATH.
  runtimeLibDirs = [
    "${cudaPackages.cuda_cudart}/lib"
    "${lib.getLib cudaPackages.libcublas}/lib"
  ];

  # CUDA's runtime and BLAS libraries, plus the driver's own (libcuda, libnvidia-ml) where NixOS keeps them:
  # serve/server.py puts these on the engine's LD_LIBRARY_PATH (cuda_dirs below).
  cudaLibDirs = runtimeLibDirs ++ [
    "/run/opengl-driver/lib"
  ];

  # What setup.py reads where a downloaded engine would have its manifest.
  engineManifest = writeText "strata-BUILD.json" (
    builtins.toJSON {
      source = "nix";
      backend = "cuda";
      inherit version;
      cuda = cudaPackages.cuda_nvcc.version;
      archs = [ (lib.toInt cudaArch) ];
      ptx = false;
      cuda_dirs = cudaLibDirs;
    }
  );

  # Upstream's tree, less the Windows/Docker scripts, the released-engine download and the benchmark fixtures.
  shipped = [
    "LICENSE"
    "README.md"
    "CMakeLists.txt"
    "requirements.txt"
    "setup.py"
    "cmake"
    "data"
    "include"
    "ref"
    "serve"
    "src"
    "tools"
    "third_party"
  ];
in
(cudaPackages.backendStdenv).mkDerivation {
  pname = "strata";
  inherit version;
  src = strataSrc;

  # The CUDA setup hooks expect both (nixpkgs' CUDA section): the include-in-cudatoolkit-root markers they read
  # are only filled in with strictDeps, and the toolkit root they build needs structured attributes.
  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    python3 # setup-patch.py
    addDriverRunpath
    cudaPackages.cuda_nvcc
    # cuda_nvcc propagates this hook, but listing it makes the toolkit root and the host compiler CMake gets
    # explicit rather than dependent on how the propagation is resolved.
    cudaPackages.setupCudaHook
  ];

  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
  ];

  postPatch = /* bash */ ''
    # llama.cpp's ggml (the CPU expert kernels the engine links) and gguf-py (the model tools), at the pinned
    # commit and trimmed to what both use: third_party/llama.cpp is where setup.py would download it.
    mkdir -p third_party/llama.cpp
    for path in ggml gguf-py LICENSE README.md; do
      cp -r ${llamaCpp}/"$path" third_party/llama.cpp/
    done
    chmod -R u+w third_party/llama.cpp

    ${lib.getExe' python3 python3.executable} ${./setup-patch.py} setup.py
  '';

  # The source root, for the phases that run inside the build directory.
  preConfigure = /* bash */ ''
    strataSrcRoot="$PWD"
    # The ggml the engine compiles from: the copy made above, not the (network) FetchContent fallback.
    cmakeFlagsArray+=("-DSTRATA_GGML_DIR=$strataSrcRoot/third_party/llama.cpp")
  '';

  cmakeFlags = [
    "-DSTRATA_ENABLE_CUDA=ON"
    "-DSTRATA_BUILD_TESTS=OFF"
    "-DSTRATA_PORTABLE=ON" # AVX2 baseline: no -march=native, so the CPU kernels run on any x86-64 with AVX2
    "-DCMAKE_CUDA_ARCHITECTURES=${cudaArch}"
    "-DCMAKE_CUDA_COMPILER=${lib.getExe cudaPackages.cuda_nvcc}"
    # The binary is not cmake-installed; building with the install RUNPATH puts these on it anyway, with
    # addDriverRunpath prepending /run/opengl-driver/lib.
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
    "-DCMAKE_INSTALL_RPATH=${lib.concatStringsSep ";" runtimeLibDirs}"
  ];

  # The engine only: not the parity tests, the micro benchmarks or the other programs the tree declares.
  ninjaFlags = [ "strata" ];

  installPhase = /* bash */ ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/strata"
    # The cmake hook configures and builds in $strataSrcRoot/build, where the `strata` target lands (Strata sets
    # no CMAKE_RUNTIME_OUTPUT_DIRECTORY of its own; only ggml's subdirectory does, for its own tools).
    install -Dm755 "$strataSrcRoot/build/strata" "$out/share/strata/engine/strata"
    install -Dm644 ${engineManifest} "$out/share/strata/engine/BUILD.json"
    ln -s ../share/strata/engine/strata "$out/bin/strata"

    # The source and support tree the wrappers use (the engine above lives in it as engine/).
    for path in ${lib.escapeShellArgs shipped}; do
      cp -r "$strataSrcRoot/$path" "$out/share/strata/"
    done

    install -Dm755 ${./strata-setup.sh} "$out/bin/strata-setup"
    install -Dm755 ${./strata-server.sh} "$out/bin/strata-server"
    substituteInPlace "$out/bin/strata-setup" "$out/bin/strata-server" \
      --replace-fail "@shareDir@" "$out/share/strata" \
      --replace-fail "@python@" "${lib.getExe' python python.executable}"

    runHook postInstall
  '';

  passthru.python = python;

  meta = {
    description = "Strata: Qwen3.8-Flash-Next inference engine (CUDA) with its setup and server";
    homepage = "https://github.com/Niko1221/Strata";
    license = lib.licenses.mit;
    mainProgram = "strata";
    platforms = [ "x86_64-linux" ];
  };
}
