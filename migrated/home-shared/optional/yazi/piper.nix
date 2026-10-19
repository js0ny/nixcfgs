_:
let
  batp = lang: ''piper -- bat --plain --color=always --language=${lang} "$1"'';
in
{
  programs.yazi.settings.plugin.prepend_previewers = [
    {
      url = "*.fnl";
      run = batp "Fennel";
    }
    {
      url = "*.nu";
      run = batp "nushell";
    }
  ];
}
