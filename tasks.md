# Module Consolidation Tasks

Goal: converge `home/`, `nixos/`, and `darwin/` into `modules/`, while keeping modules composable and host configurations explicit.

## Direction

- Do not add a `modules/profiles/` layer.
- Prefer small, named modules over inherited profiles such as `desktop-extra`.
- Prefer composition over inheritance: hosts or suite modules should import a list of capabilities.
- Keep public imports on `inputs.self.homeModules.*`, `inputs.self.nixosModules.*`, and `inputs.self.darwinModules.*`.
- Use `modules/**/default.nix` as the public export point, because `flakes/modules.nix` already scans those recursively.
- Use nested flake-parts composition when a larger module is useful.

Example:

```nix
flake.nixosModules.core =
  { inputs, ... }:
  {
    imports = [
      inputs.self.nixosModules.nix
      inputs.self.nixosModules.ssh
      inputs.self.nixosModules.packages-core
    ];
  };
```

## Target Shape

```text
modules/
  core/
  suites/
    home/
    nixos/
    darwin/
  programs/
  services/
  desktop/
  hardware/
  virtualisation/
  security/
  options/
    home/
    shared/
```

`suites/` is optional and should stay thin. It is only for named compositions that are actually reused or make host files clearer, not for recreating `home/desktop-base.nix` and `home/desktop-extra.nix` as an inheritance hierarchy.

## Naming Rules

- Name modules by capability, not by machine role, where possible.
- Good names: `nixosModules.audio`, `nixosModules.networkmanager`, `homeModules.plasma`, `homeModules.nixvim`, `darwinModules.finder`.
- Acceptable suite names: `homeModules.linux-common`, `homeModules.desktop-common`, `nixosModules.desktop-common`, `darwinModules.mac-common`.
- Avoid names that encode inheritance tiers: `desktop-base`, `desktop-extra`, `server-base`.
- If only one host uses a composition, keep the composition in that host instead of creating a suite.

## Phase 1: Fix Existing Inconsistencies

- [x] Fix `darwin/default.nix` importing missing `./sshd.nix`.
- [x] Use the existing `inputs.self.darwinModules.sshd` implementation from `modules/services/sshd/default.nix`.
- [x] Review `modules/core/default.nix`, `modules/core/packages.nix`, and `modules/core/ssh.nix`, because they define the same `flake.*Modules.core` names in multiple files.
- [x] Split `core` into smaller public capabilities where it makes sense, then compose `core` from those capabilities through nested flake-parts imports.
- [x] Keep `core` as a compatibility suite only if hosts already depend on it heavily.

## Phase 2: Create Capability Exports Before Moving Files

- [x] Add exports for NixOS desktop pieces currently under `nixos/desktop/*`:
  - [x] `nixosModules.audio`.
  - [x] `nixosModules.bluetooth`.
  - [x] `nixosModules.desktop-sessions`.
  - [x] `nixosModules.display-manager`.
  - [x] `nixosModules.firmware`.
  - [x] `nixosModules.gnome-keyring`.
  - [x] `nixosModules.gui`.
  - [x] `nixosModules.i2c`.
  - [x] `nixosModules.input`.
  - [x] `nixosModules.lanzaboote`.
  - [x] `nixosModules.laptop`.
  - [x] `nixosModules.networkmanager`.
  - [x] `nixosModules.peripherals`.
- [x] Add a thin `nixosModules.desktop` suite (replaces `desktop-common`).
- [x] Add exports for NixOS server pieces currently under `nixos/server/*`:
  - [x] `nixosModules.acme`.
  - [x] `nixosModules.nginx`.
  - [x] `nixosModules.server-core`.
  - [x] `nixosModules.server-networking`.
- [x] Add a thin `nixosModules.server` suite (replaces `server-common`).
- [x] Add exports for Darwin pieces currently under `darwin/*`:
  - [x] `darwinModules.brew`.
  - [x] `darwinModules.darwin-core` (split from `core` to avoid conflict).
  - [x] `darwinModules.determinate`.
  - [x] `darwinModules.finder`.
  - [x] `darwinModules.pam`.
  - [x] `darwinModules.stylix`.
  - [x] `darwinModules.tailscale` from `modules/core/tailscale.nix`.
- [x] Add a `darwinModules.darwin` suite (replaces `mac-common`).
- [x] Add exports for Home Manager top-level compositions:
  - [x] `homeModules.linux-common` for current `home/linux-base.nix` content.
  - [x] `homeModules.darwin` for current `home/darwin-base.nix` content.
  - [x] `homeModules.wsl` for current `home/wsl.nix` content.
  - [x] `homeModules.server` for current `home/server-base.nix` content.
  - [ ] `homeModules.desktop-common` only for genuinely common desktop imports.
- [ ] Do not recreate `homeModules.desktop-extra`; move its imports into the relevant host or into specific capability modules.

## Phase 3: Switch Hosts To Composition

- [x] Replace direct `../../nixos/desktop` imports with `../../nixos` + `inputs.self.nixosModules.desktop`.
- [x] Replace direct `../../nixos/server` imports with `../../nixos` + `inputs.self.nixosModules.server`.
- [x] Replace direct `../../darwin` import in `hosts/zen/default.nix` with shared base + `inputs.self.darwinModules.darwin`.
- [ ] Replace direct Home Manager imports in `hosts/*/home.nix` with explicit `inputs.self.homeModules.*` imports; server/wsl/darwin homes done, desktop hosts deferred until Phase 5 decomposition.
- [x] Keep host-specific choices in `hosts/`, especially large desktop/program selections that are not reused.
- [x] Leave host-specific files such as `./vars.nix`, `./disko.nix`, and hardware config files in `hosts/`.

## Phase 4: Move NixOS Modules

- [x] Move `nixos/desktop/*` into `modules/desktop/*`.
- [x] Move `nixos/server/*` into `modules/server/*`.
- [x] Move `nixos/hardware/*` into `modules/hardware/*`, keeping existing migrated hardware modules such as `wsl` and `asus` consistent.
- [x] Move NixOS services from `nixos/services/*` to `modules/services/*` in small batches.
- [x] Start with services referenced directly by hosts:
  - [x] `sunshine`.
  - [x] `cloudflare`.
  - [x] `fail2ban`.
  - [ ] `authelia`.
  - [ ] `matrix`.
  - [ ] `hermes-agent`.
  - [ ] `jellyfin`.
  - [ ] `librechat`.
  - [ ] `litellm`.
  - [x] `prometheus`.
  - [x] `bentopdf`.
  - [x] `miniflux`.
  - [x] `opengist`.
  - [x] `postgresql`.
  - [x] `radicale`.
  - [x] `rclone`.
  - [x] `uptime-kuma`.
  - [x] `valkey`.
  - [x] `fast-note-sync`.
  - [x] `forgejo`.
  - [x] `forgejo-runner`.
  - [x] `garage`.
  - [x] `gluetun`.
  - [x] `grafana`.
  - [x] `karakeep`.
  - [x] `lobehub`.
  - [x] `mongodb`.
  - [x] `navidrome`.
  - [x] `nextcloud`.
  - [x] `paperless`.
  - [x] `rsshub`.
  - [x] `searxng`.
  - [x] `sub2api`.
  - [x] `telegram-inline-llm-bot`.
  - [x] `vikunja`.
  - [x] `meilisearch`.
- [x] For each migrated service, expose `flake.nixosModules.<name>` from its new `default.nix`.
- [x] Replace host service imports with `inputs.self.nixosModules.<name>`.
- [x] Update `definitions/llm.nix`, which currently imports `../nixos/services/litellm/litellm-models.nix`.

## Phase 5: Move Home Manager Modules

- [ ] Move `home/core/*` into `modules/core/home/*` or split into specific capabilities.
- [ ] Move `home/options/*` into `modules/options/home/*`.
- [ ] Move `home/devenvs/*` into `modules/devenvs/*` or `modules/programs/devenvs/*`.
- [ ] Move `home/filetype/*` into `modules/filetype/*` or `modules/desktop/filetype/*`.
- [ ] Move `home/desktop/*` into `modules/desktop/*` and expose named home modules such as:
  - [ ] `homeModules.plasma`.
  - [ ] `homeModules.gnome`.
  - [ ] `homeModules.hyprland`.
  - [ ] `homeModules.niri`.
- [ ] Move `home/gaming/*` into `modules/programs/gaming/*`, merging with existing `modules/programs/gaming/steam` where appropriate.
- [ ] Move remaining `home/programs/*` into `modules/programs/*`.
- [ ] For modules that already exist in `modules/programs/*`, merge the old Home Manager config into the existing cross-platform module instead of creating duplicates.
- [ ] Keep large per-host app bundles in host files unless two or more hosts share the same bundle.

## Phase 6: Move Darwin Modules

- [x] Move `darwin/core.nix` into `modules/darwin/core.nix` (exported as `darwinModules.darwin-core`).
- [x] Move `darwin/brew.nix` into `modules/darwin/brew.nix`.
- [x] Move `darwin/finder.nix` into `modules/darwin/finder.nix`.
- [x] Move `darwin/pam.nix`, `darwin/stylix.nix`, and `darwin/determinate.nix` into `modules/darwin/`; merge Darwin tailscale into `modules/core/tailscale.nix`.
- [x] Expose standalone reusable pieces as `flake.darwinModules.<name>`.
- [x] Compose `darwinModules.darwin` suite (replaces `mac-common`).

## Phase 7: Clean Path-Sensitive References

- [x] Search for direct old tree references after moves:
  - [x] `../../home/`.
  - [x] `../../nixos/`.
  - [x] `../../darwin`.
  - [x] `../nixos/`.
  - [x] `${dots}/home/`.
- [x] Update symlink sources that currently point into `home/`, including known references in:
  - [x] `home/programs/productivity/okular/default.nix`.
  - [x] `home/desktop/hyprland/default.nix`.
  - [x] `home/programs/editors/lsp-snippets/default.nix`.
  - [x] `home/programs/editors/vscode/default.nix`.
  - [x] `home/programs/editors/emacs/default.nix`.
  - [x] `home/programs/editors/nvim/default.nix`.
- [x] Update stale comments that reference old paths, for example `modules/nixos/programs/firefox.nix`.

## Phase 8: Remove Old Trees

- [x] Confirm no live imports reference `home/`, `nixos/`, or `darwin/`.
- [x] Delete empty or obsolete old directories.
- [ ] Keep `hosts/`, `common/`, `definitions/`, `options/`, and `overlays/` separate unless there is a later decision to consolidate them too.

## Verification

- [ ] Run full check when feasible:

```bash
nix flake check
```

- [ ] If full check is too slow, evaluate affected hosts individually:

```bash
nix eval .#nixosConfigurations.bauhaus.config.system.build.toplevel.drvPath
nix eval .#nixosConfigurations.crystal.config.system.build.toplevel.drvPath
nix eval .#nixosConfigurations.polder.config.system.build.toplevel.drvPath
nix eval .#nixosConfigurations.zwinger.config.system.build.toplevel.drvPath
nix eval .#nixosConfigurations.wsl-crystal.config.system.build.toplevel.drvPath
nix eval .#darwinConfigurations.zen.config.system.build.toplevel.drvPath
```

## Known Risks

- Moving files that are used as symlink sources through `${dots}/home/...` can break runtime config links unless those paths are updated.
- Service directories with helper files, such as `litellm`, `librechat`, `jellyfin`, `matrix`, and `prometheus`, should move as a unit.
- Suite modules can quietly become another profile hierarchy; only create them when they reduce real duplication.
