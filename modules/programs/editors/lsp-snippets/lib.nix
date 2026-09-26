{ config, ... }:
let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dots = config.js0ny.host.flakeDir;

  # out: with package.json definitions required by neovim luasnip.
  out = mkSymlink "${dots}/modules/programs/editors/lsp-snippets";
  # raw: actual snippets only, zed and vscode reads this path directly.
  raw = mkSymlink "${dots}/modules/programs/editors/lsp-snippets/snippets";
in
{
  inherit out raw;
}
