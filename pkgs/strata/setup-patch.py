#!/usr/bin/env python3
"""Patch Strata's setup.py for a Nix-provided engine and Python environment (pkgs/strata).

Nix builds the engine and supplies the Python packages, so the packaged setup must neither compile nor download
the engine and must not pip-install anything: its tree is read-only, and the host has no toolkit. Every other step
- the PC checks, the model download, the pack build, the run config, the start script - is upstream's, reused
unchanged.

Each function is replaced whole and located through the syntax tree, so an upstream rename fails this script (and
so the build) instead of silently leaving the old behaviour in place.
"""

from __future__ import annotations

import ast
import sys
from pathlib import Path

PIP_INSTALL = '''
def pip_install(packages, what):
    """The Nix Python environment (pkgs/strata's passthru.python) already provides these: setup.py installs
    nothing, and nothing may be installed - its tree is a read-only store path."""
    ok(f"{what}: provided by the Nix Python environment")
'''

GET_PREBUILT = '''
def get_prebuilt(url_base, gpu, vision, updating=False) -> Path:
    """The engine Nix built, linked into ROOT as engine/ (never downloaded, never compiled here).  Its BUILD.json
    is the manifest the run config's library paths and the version checks read."""
    eng = ROOT / "engine"
    if not (eng / EXE).exists():
        fail("no engine in this Strata root",
             "run the packaged strata-setup: it links the Nix tree, engine included, into STRATA_ROOT")
    meta = json.loads((eng / "BUILD.json").read_text(encoding="utf-8"))
    ok(f"engine {meta.get('version')} for " + ", ".join('sm_' + str(a) for a in meta.get("archs", []))
       + " (built by Nix)")
    return eng
'''

UPDATE_INSTALLED_ENGINE = '''
def update_installed_engine(url_base) -> None:
    """Nothing to replace: the engine is the one Nix built, and the setup links the current one into ROOT."""
'''

BUILD_ENGINE = '''
def build_engine(gpu, vision, yes, llama) -> Path:
    """Setup never compiles: pkgs/strata builds the engine with the CUDA toolkit and llama.cpp that Nix provides."""
    fail("this setup does not build the engine",
         "Nix builds it, so update it with the system (nixos-rebuild) and run setup again")
'''

GET_LLAMA_CPP = '''
def get_llama_cpp():
    """llama.cpp's ggml (the CPU expert kernels the engine links) and gguf-py (the model tools) at the commit
    CMakeLists.txt pins: the Nix source tree, never a download."""
    llama = ROOT / "third_party" / "llama.cpp"
    if not (llama / "ggml" / "CMakeLists.txt").exists() or not (llama / "gguf-py").is_dir():
        fail("llama.cpp's source is missing from this Strata root",
             "run the packaged strata-setup: it links the Nix tree, third_party included, into STRATA_ROOT")
    return llama
'''

REPLACEMENTS = {
    "pip_install": PIP_INSTALL,
    "get_prebuilt": GET_PREBUILT,
    "update_installed_engine": UPDATE_INSTALLED_ENGINE,
    "build_engine": BUILD_ENGINE,
    "get_llama_cpp": GET_LLAMA_CPP,
}


def target_lines(text: str, name: str) -> tuple[int, int]:
    """The first and last line (1-based, both inclusive) of the top-level function `name`."""
    found = [
        node
        for node in ast.parse(text).body
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)) and node.name == name
    ]
    if len(found) != 1:
        raise SystemExit(f"setup-patch.py: expected exactly one top-level {name}(), found {len(found)}")
    node = found[0]
    first = min([node.lineno, *[decorator.lineno for decorator in node.decorator_list]])
    return first, node.end_lineno


def replace(text: str, name: str, new: str) -> str:
    first, last = target_lines(text, name)
    lines = text.splitlines(keepends=True)
    return "".join(lines[: first - 1]) + new.strip("\n") + "\n" + "".join(lines[last:])


def main() -> int:
    path = Path(sys.argv[1] if len(sys.argv) > 1 else "setup.py")
    text = path.read_text(encoding="utf-8")
    for name, new in REPLACEMENTS.items():
        text = replace(text, name, new)
    ast.parse(text)                                   # a replacement that does not parse stops the build here
    path.write_text(text, encoding="utf-8")
    print(f"setup-patch.py: replaced {', '.join(REPLACEMENTS)} in {path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
