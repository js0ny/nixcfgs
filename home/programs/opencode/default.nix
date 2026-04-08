{...}: {
  xdg.configFile."opencode/oh-my-opencode.json".text = builtins.toJSON (import ./oh-my-openagent.nix);

  nixdots.persist.home = {
    directories = [
      ".local/share/opencode"
      ".config/opencode"
    ];
  };

  programs.opencode = {
    enable = true;
    settings = {
      autoupdate = false;
      model = "openai/gpt-5.4";
    };
  };
}
