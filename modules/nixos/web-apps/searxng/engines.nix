{
  services.searx.settings = {
    engines = [
      {
        name = "braveapi";
        engine = "braveapi";
        api_key = "$BRAVE_SEARCH_API_KEY";
      }
    ];
    #   use_default_settings.engines.keep_only = [
    #     "startpage"
    #     "brave"
    #     "duckduckgo"
    #     "github"
    #     "stackoverflow"
    #     "reddit"
    #     "wikipedia"
    #     "arch linux wiki"
    #     "nixos wiki"
    #     "npm"
    #     "pypi"
    #     "crates.io"
    #     "arxiv"
    #   ];
    #   engines = [
    #     {
    #       name = "startpage";
    #       shortcut = "sp";
    #       timeout = 2.0;
    #       disabled = false;
    #     }
    #     {
    #       name = "brave";
    #       shortcut = "b";
    #       timeout = 2.0;
    #       weight = 1.2;
    #       disabled = false;
    #     }
    #     {
    #       name = "duckduckgo";
    #       shortcut = "ddg";
    #       timeout = 1.8;
    #       disabled = false;
    #     }
    #     {
    #       name = "github";
    #       shortcut = "gh";
    #       timeout = 2.0;
    #       disabled = false;
    #     }
    #     {
    #       name = "stackoverflow";
    #       shortcut = "so";
    #       timeout = 2.0;
    #       disabled = false;
    #     }
    #     {
    #       name = "reddit";
    #       shortcut = "r";
    #       timeout = 2.5;
    #       disabled = false;
    #     }
    #     {
    #       name = "arch linux wiki";
    #       shortcut = "aw";
    #       disabled = false;
    #     }
    #     {
    #       name = "nixos wiki";
    #       shortcut = "nw";
    #       disabled = false;
    #     }
    #     {
    #       name = "npm";
    #       disabled = false;
    #     }
    #     {
    #       name = "crates.io";
    #       disabled = false;
    #     }
    #     # {
    #     #   name = "nixpkgs";
    #     #   engine = "command";
    #     #   shortcut = "np";
    #     #   timeout = 1.0;
    #     #   command = [
    #     #     (lib.getExe pkgs.python3)
    #     #     "-c"
    #     #     /* python */ ''
    #     #       import sys, urllib.parse
    #     #
    #     #       query = " ".join(sys.argv[1:])
    #     #       url = "https://search.nixos.org/packages?channel=unstable&query=" + urllib.parse.quote_plus(query)
    #     #       print(f"Nixpkgs packages\t{url}\tSearch NixOS packages for {query}")
    #     #     ''
    #     #     "{{QUERY}}"
    #     #   ];
    #     #   delimiter = {
    #     #     chars = "\t";
    #     #     keys = [
    #     #       "title"
    #     #       "url"
    #     #       "content"
    #     #     ];
    #     #   };
    #     #   disabled = false;
    #     # }
    #   ];
  };
}
