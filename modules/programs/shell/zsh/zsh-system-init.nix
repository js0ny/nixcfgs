{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  zsh-patina = inputs.zsh-patina.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
/* zsh */ ''
  bindkey -e # Emacs

  setopt AUTOCD
  setopt EXTENDED_GLOB

  eval "$(${lib.getExe' zsh-patina "zsh-patina"} activate)"

  ### completion
  ### =================

  # use tab to select
  zstyle ':completion:*' menu select

  # substring matching
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

  # use cache
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

  # Colours in completion
  zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

  # Complete . and .. special directories
  zstyle ':completion:*' special-dirs true

  # edit command line
  autoload -Uz edit-command-line
  zle -N edit-command-line

  # Key bindings (Emacs with modern enhancement)
  # ===============================================

  bindkey '^H' backward-kill-word   # Ctrl-Backspace
  bindkey '^[^?' backward-kill-line # Alt-Backspace

  bindkey '^[[1;5D' backward-word  # Ctrl-Left
  bindkey '^[[1;5C' forward-word   # Ctrl-Right

  bindkey '^[[1;3D' beginning-of-line # Alt-Left
  bindkey '^[[1;3C' end-of-line # Alt-Right


  bindkey '^[[H' beginning-of-line # Home
  bindkey '^[[F' end-of-line       # End


  bindkey '^[[3~' delete-char # Delete
  bindkey '^[[3;5~' kill-word # Ctrl-Delete
  bindkey '^[[3;3~' kill-line # Alt-Delete

  bindkey '^X^E' edit-command-line
  bindkey '^[e' edit-command-line
  bindkey '^[v' edit-command-line

  bindkey '^[[Z' reverse-menu-complete # Shift-Tab
  # bindkey -M menuselect '^[[Z' reverse-menu-complete # Shift-Tab in menu select mode

  bindkey '^[#' pound-insert # Alt-# to comment line

  bindkey '^]' vi-find-next-char
  bindkey '^[^]' vi-find-prev-char

  # Minimal prompt
  # if under `root` then mark username red
  PROMPT='%(#.%F{red}.%F{green})%n%f@%F{magenta}%m%f %F{blue}%B%~%b%f %# '
  RPROMPT='[%F{yellow}%?%f]'

  copy-osc52() {
    local data
    data="$(printf '%s' "$BUFFER" | base64 | tr -d '\n')"
    printf '\e]52;c;%s\a' "$data"
  }

  zle -N copy-osc52
  bindkey '^X' copy-osc52

  ${builtins.readFile ./zsh_clipboard_paste.zsh}
  bindkey '^V' zsh_clipboard_paste
''
