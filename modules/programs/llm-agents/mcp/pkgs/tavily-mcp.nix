{
  writeShellApplication,
  coreutils,
  nodejs,
  apiKeyPath,
  ...
}:
writeShellApplication {
  name = "tavily-mcp";

  runtimeInputs = [
    coreutils
    nodejs
  ];

  text = ''
    secret_file="${apiKeyPath}"

    if [ ! -r "$secret_file" ]; then
      echo "tavily-mcp: cannot read tavily API key at $secret_file" >&2
      exit 1
    fi

    TAVILY_API_KEY="$(cat "$secret_file")"
    export TAVILY_API_KEY

    exec npx -y tavily-mcp@0.1.3
  '';
}
