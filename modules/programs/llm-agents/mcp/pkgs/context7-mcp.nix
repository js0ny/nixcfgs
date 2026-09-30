{
  writeShellApplication,
  coreutils,
  nodejs,
  apiKeyPath,
  ...
}:
writeShellApplication {
  name = "context7-mcp";

  runtimeInputs = [
    coreutils
    nodejs
  ];

  text = ''
    secret_file="${apiKeyPath}"

    if [ ! -r "$secret_file" ]; then
      echo "context7-mcp: cannot read Context7 API key at $secret_file" >&2
      exit 1
    fi

    CONTEXT7_API_KEY="$(cat "$secret_file")"
    export CONTEXT7_API_KEY

    export CTX7_TELEMETRY_DISABLED=1

    exec npx -y @upstash/context7-mcp
  '';
}
