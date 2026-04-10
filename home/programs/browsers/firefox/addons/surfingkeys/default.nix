{ config, ... }:
let
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  programs.firefox.profiles."${p}".surfingkeys = {
    enable = true;
    showAdvanced = true;
    blocklist = [
      "https://svelte.dev"
      "https://docs-editor.proton.me"
      "https://www.shoutoutuk.org"
      "https://www.notion.so"
    ];
    snippets = builtins.readFile ./surfingkeys.js;
  };
}
