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

[macos]
eval-os args="" host=hostname extra="":
    {{ EVAL }} ".#darwinConfigurations.{{ host }}.config.{{ args }}" {{ extra }}

[linux]
locate-os args="" host=hostname extra="":
    {{ EVAL }} '.#nixosConfigurations.{{ host }}.options.{{ args }}.definitionsWithLocations' {{ extra }}


[linux]
eval-home args="" host=hostname extra="":
    {{ EVAL }} ".#nixosConfigurations.{{ host }}.config.home-manager.users.{{ env_var("USER") }}.{{ args }}" {{ extra }}

[macos]
locate-os args="" host=hostname extra="":
    {{ EVAL }} '.#darwinConfigurations.{{ host }}.options.{{ args }}.definitionsWithLocations' {{ extra }}

[macos]
locate-home args="" host=hostname extra="":
    {{ EVAL }} '.#darwinConfigurations.{{ host }}.options.home-manager.users.{{ env_var("USER") }}.{{ args }}.definitionsWithLocations' {{ extra }}

[macos]
eval-home args="" host=hostname extra="":
    {{ EVAL }} ".#darwinConfigurations.{{ host }}.config.home-manager.users.{{ env_var("USER") }}.{{ args }}" {{ extra }}

[linux]
journal-home username=env_var("USER"):
    journalctl -xeu home-manager-{{ username }}.service

update-nixpkgs:
    nix flake update nixpkgs nixpkgs-unfree nixpkgs-stable

[linux]
depends-system host=hostname:
    {{EVAL}} ".#nixosConfigurations.{{ host }}.options.environment.systemPackages.definitionsWithLocations" --json | jless

issue-search query repo="NixOS/nixpkgs":
    gh issue list --repo {{ repo }} --search {{ query }}

pr-search query repo="NixOS/nixpkgs":
    gh pr list --repo {{ repo }} --search {{ query }}

issue-view number web="" repo="NixOS/nixpkgs":
    gh issue view --repo {{ repo }} {{ number }} {{ web }}

pr-view number web="" repo="NixOS/nixpkgs":
    gh pr view --repo {{ repo }} {{ number }} {{ web }}
