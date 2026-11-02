{
  lib,
  writeShellApplication,
  coreutils,
}:
writeShellApplication {
  name = "clipboard-copy";
  text = /* bash */ ''
    backend=auto
    case "$#:''${1:-}" in
      0:) ;;
      1:--help)
        printf '%s\n' \
          'Usage: clipboard-copy [--backend BACKEND] < input' \
          'Backends: auto, osc52, pbcopy, wl-copy, xsel, xclip, clip.exe'
        exit 0
        ;;
      2:--backend) backend="$2" ;;
      *)
        printf '%s\n' 'Usage: clipboard-copy [--backend BACKEND] < input' >&2
        exit 1
        ;;
    esac

    if [[ "$backend" == auto ]]; then
      # SSH sessions must target the client clipboard, even with display forwarding.
      if [[ -n "''${SSH_CONNECTION:-}" || -n "''${SSH_TTY:-}" ]]; then
        backend=osc52
      elif command -v pbcopy >/dev/null; then
        backend=pbcopy
      elif [[ -n "''${WAYLAND_DISPLAY:-}" ]] && command -v wl-copy >/dev/null; then
        backend=wl-copy
      elif [[ -n "''${DISPLAY:-}" ]] && command -v xsel >/dev/null; then
        backend=xsel
      elif [[ -n "''${DISPLAY:-}" ]] && command -v xclip >/dev/null; then
        backend=xclip
      elif command -v clip.exe >/dev/null; then
        backend=clip.exe
      else
        backend=osc52
      fi
    fi

    case "$backend" in
      osc52)
        if [[ "''${TERM:-dumb}" == dumb ]]; then
          printf '%s\n' 'clipboard-copy: OSC 52 requires a capable terminal' >&2
          exit 1
        fi
        if [[ -n "''${TMUX:-}" ]]; then
          # Let tmux emit OSC 52 without requiring passthrough configuration.
          exec tmux load-buffer -w -
        fi
        encoded="$(${lib.getExe' coreutils "base64"} --wrap=0)"
        printf '\033]52;c;%s\a' "$encoded" > /dev/tty
        ;;
      pbcopy) exec pbcopy ;;
      wl-copy) exec wl-copy ;;
      xsel) exec xsel --clipboard --input ;;
      xclip) exec xclip -selection clipboard ;;
      clip.exe) exec clip.exe ;;
      *)
        printf 'clipboard-copy: unknown backend: %s\n' "$backend" >&2
        exit 1
        ;;
    esac
  '';
  meta = {
    description = "Copy standard input to the desktop or terminal clipboard";
    homepage = "https://github.com/js0ny/nixcfgs/tree/main/pkgs/clipboard-copy";
    license = lib.licenses.gpl3Only;
    mainProgram = "clipboard-copy";
  };
}
