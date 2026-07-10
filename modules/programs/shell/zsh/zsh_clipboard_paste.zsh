zsh_clipboard_paste() {
  emulate -L zsh

  local data marker=$'\1'

  if [[ -n ${SSH_CONNECTION-} && ${TERM-} == xterm-kitty && -n ${commands[kitten]-} ]]; then
    data="$(kitten clipboard -g 2>/dev/null; printf '%s' "$marker")"
  elif (( ${+commands[pbpaste]} )); then
    data="$(pbpaste 2>/dev/null; printf '%s' "$marker")"
  elif [[ -n ${WAYLAND_DISPLAY-} && -n ${commands[wl-paste]-} ]]; then
    data="$(wl-paste -n 2>/dev/null; printf '%s' "$marker")"
  elif [[ -n ${DISPLAY-} && -n ${commands[xsel]-} ]]; then
    data="$(xsel --clipboard 2>/dev/null; printf '%s' "$marker")"
  elif [[ -n ${DISPLAY-} && -n ${commands[xclip]-} ]]; then
    data="$(xclip -selection clipboard -o 2>/dev/null; printf '%s' "$marker")"
  elif (( ${+commands[powershell.exe]} )); then
    data="$(powershell.exe Get-Clipboard 2>/dev/null | sed $'s/\r$//'; printf '%s' "$marker")"
  else
    return 1
  fi

  data=${data%$marker}

  if [[ -z $data ]]; then
    return 1
  fi

  if [[ ! -t 1 ]]; then
    printf '%s' "$data"
    return
  fi

  if (( ${+WIDGET} )); then
    LBUFFER+=$data
    zle redisplay
    return
  fi

  printf '%s' "$data"
}

zle -N zsh_clipboard_paste
