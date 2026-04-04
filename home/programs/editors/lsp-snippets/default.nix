{config, ...}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dots = config.nixdots.core.dots;

  # out: with package.json definitions required by neovim luasnip.
  out = mkSymlink "${dots}/home/programs/editors/lsp-snippets";
  # raw: actual snippets only, zed and vscode reads this path directly.
  raw = mkSymlink "${dots}/home/programs/editors/lsp-snippets/snippets";
in {
  inherit out raw;
}
