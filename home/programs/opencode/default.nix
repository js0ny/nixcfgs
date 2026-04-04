{
  pkgs,
  config,
  inputs,
  ...
}: {
  home.packages = [
    # 安装 OpenCode 本体
    pkgs.opencode
    inputs.llm-agents.packages.${pkgs.system}.oh-my-opencode
  ];

  # 声明式接管 ~/.config/opencode/oh-my-opencode.json
  xdg.configFile."opencode/oh-my-opencode.json".text = builtins.toJSON (import ./oh-my-openagent.nix);

  nixdots.persist.home = {
    directories = [
      ".local/share/opencode"
      ".config/opencode"
    ];
  };
}
