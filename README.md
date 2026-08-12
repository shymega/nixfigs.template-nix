# shy-nixfigs

A minimal Nix flake template distilled from the abstractions in
[shymega/nixfigs](https://github.com/shymega/nixfigs) (this repository), on
its `refactor/mk-v` branch.

## What it borrows from nixfigs

- **`mkHost`** (`hosts/default.nix`) — a record-builder for host definitions,
  asserting `hostPlatform` matches the declared `type` (`nixos` /
  `home-manager`), same shape as `hosts/default.nix` in the parent repo.
- **`declarations/enabled.d/`** (`hosts/declarations/enabled.d/`) — drop one
  file per host to enable it; `hosts/default.nix` picks up everything in the
  directory via `listFilesRecursive`, exactly like nixfigs.
- **Roles** (`nix-support/roles.nix`) — a closed vocabulary + `checkRoles`
  helper for gating modules on `hostRoles`.
- **Systems module** (`nix-support/systems.nix`) — centralized system lists
  and `forEachSystem`/`forDevSystems` helpers.
- **devshell / formatter / checks** (`nix-support/*.nix`) — the same
  treefmt-nix + git-hooks.nix wiring as nixfigs' `nix-support/`.
- **`src/systems/<hostname>@<system>/`** and **`src/homes/<user>@<system>/`**
  — per-host and per-user module trees, same naming convention as nixfigs'
  `src/systems/` and `src/homes/`.

## What's different (for now)

Per-branch request, this template does **not** redefine its own overlay
tree or package set. Instead `flake.nix` pulls `overlays`, `packages`, and
`nixpkgs-config` straight from the `nixfigs` input:

```nix
overlays = nixfigs.overlays;
packages = nixfigs.packages;
nixpkgs-config = nixfigs.nixpkgs-config;
```

`nixpkgs` itself follows `nixfigs/nixpkgs`, so this template always builds
against the exact same package set as the parent repo's `refactor/mk-v`
branch. This keeps the template lightweight while it's still being shaped;
once it needs to diverge, replace those three `nixfigs.*` references with a
local `overlays/` tree (see nixfigs' `overlays/default.nix` for the
stable/unstable enabled.d pattern) and drop the `nixfigs` input.

## Layout

```text
flake.nix                            inputs + outputs wiring
nix-support/
  roles.nix                          role vocabulary + checkRoles
  systems.nix                        system lists + genAttrs helpers
  devshell.nix                       default devShell
  formatter.nix                      treefmt-nix config
  checks.nix                         git-hooks.nix pre-commit config
hosts/
  default.nix                        mkHost + enabled.d loader
  nixos/default.nix                  nixosSystem generator
  homes/default.nix                  homeManagerConfiguration generator
  declarations/enabled.d/
    example-nixos.nix                one enabled host
src/
  modules/core/default.nix           foundation module, all hosts import it
  systems/example-nixos@x86_64-linux/
                                      example host's module tree
  homes/example-user@x86_64-linux/
                                      example user's home-manager tree
```

## Adding a host

1. Add a module tree at `src/systems/<hostname>@<system>/default.nix`.
1. If it has a user, add `src/homes/<username>@<system>/default.nix`.
1. Drop a file in `hosts/declarations/enabled.d/` calling `mkHost { ... }`.

## Usage

```console
nix flake check
nixos-rebuild build --flake .#example-nixos
```
