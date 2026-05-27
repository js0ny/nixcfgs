{ pkgs, lib, ... }:
{
  programs.nixvim.globalOpts = {
    number = true;
    relativenumber = true;
    shell = lib.getExe pkgs.fish;
    termguicolors = true;
    mouse = "a";
    ignorecase = true;
    smartcase = true;
    encoding = "utf-8";
    fileencoding = "utf-8";
    cursorline = true;
    linebreak = true;
    cmdheight = 0;
    laststatus = 3;
    conceallevel = 2;
    mousemoveevent = true;
    confirm = true;
    scrolloff = 5;
    sidescrolloff = 10;
    expandtab = true;
    shiftwidth = 4;
    tabstop = 4;
    shiftround = true;
    smartindent = false;
    autoindent = true;
    grepprg = "${lib.getExe pkgs.ripgrep} --vimgrep --no-heading --smart-case";
    grepformat = "%f:%l:%c:%m";
    exrc = true;
    foldmethod = "expr";
    foldexpr = "v:lua.vim.treesitter.foldexpr()";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
  };
}
