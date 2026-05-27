{ ... }:
{
  programs.nixvim = {
    autoCmd = [
      {
        event = [
          "BufRead"
          "BufNewFile"
        ];
        pattern = "*";
        command = "syntax match ShortWord \"\\<\\w\\{1,2}\\>\" contains=@NoSpell";
      }
    ];

    extraConfigLua = ''
      vim.fn.matchadd('Conceal', [[\%u200b]], 10, -1, { conceal = "" })

    '';
  };
}
