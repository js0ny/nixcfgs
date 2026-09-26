{
  flake.homeModules.editors = _: {
    nixdefs = {
      lsp.enable = true;
      mcp.enable = true;
    };
    js0ny.persist.stores.state.directories = [
      {
        directory = ".config/github-copilot";
        mode = "0700";
      }
    ];
  };
}
