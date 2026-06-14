update:
    nix flake update
    @just update-models

repl:
    nix repl --expr 'import <nixpkgs> {}'

update-models:
    http get https://openrouter.ai/api/v1/models | jq > _sources/openrouter.json
    http get https://models.dev/api.json | jq > _sources/models.json
