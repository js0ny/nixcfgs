EVAL := f"nix eval --pretty --quiet --quiet"
hostname := `hostname`

update:
    nix flake update
    @just update-models

repl:
    nix repl --expr 'import <nixpkgs> {}'

update-models:
    http get https://openrouter.ai/api/v1/models | jq > _sources/openrouter.json
    http get https://models.dev/api.json | jq > _sources/models.json

[linux]
eval-os args="" host=hostname extra="":
    {{ EVAL }} ".#nixosConfigurations.{{ host }}.config.{{ args }}" {{ extra }}

[linux]
eval-home args="" host=hostname extra="":
    {{ EVAL }} ".#nixosConfigurations.{{ host }}.config.home-manager.users.{{ env_var("USER") }}.{{ args }}" {{ extra }}
