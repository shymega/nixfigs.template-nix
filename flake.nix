# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
{
  description = "shy-nixfigs: a Nix flake template distilled from shymega/nixfigs";

  outputs = inputs: let
    inherit (inputs) self nixfigs;
    rolesModule = import ./nix-support/roles.nix;
    systemsModule = import ./nix-support/systems.nix {inherit inputs;};
    inherit (systemsModule) treefmtSystems forDevSystems;
    treeFmtEachSystem = f: inputs.nixpkgs.lib.genAttrs treefmtSystems (system: f inputs.nixpkgs.legacyPackages.${system});
    treeFmtEval = treeFmtEachSystem (
      pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./nix-support/formatter.nix
    );
  in {
    inherit (rolesModule) roles;
    inherit (rolesModule) utils;

    # Inherited wholesale from nixfigs (this repo, `refactor/mk-v` branch) for now,
    # so this template tracks the same package set/overlays as its parent until it
    # grows an overlay tree of its own.
    inherit (nixfigs) nixpkgs-config;
    inherit (nixfigs) overlays;
    inherit (nixfigs) packages;

    genPkgs = system:
      import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.overlays;
        config = self.nixpkgs-config;
      };

    homeConfigurations = import ./hosts/homes {inherit inputs self;};
    nixosConfigurations = import ./hosts/nixos {inherit inputs self;};

    hosts = with builtins; let
      lak = list:
        listToAttrs (
          map (v: {
            name = v.hostname or "home-manager-cfg";
            value = v;
          })
          list
        );
      raw = import ./hosts {inherit self inputs;};
    in
      lak (
        map (
          v:
            import v {
              inherit self inputs;
              inherit (raw) mkHost;
            }
        )
        raw.enabled
      );

    formatter = treeFmtEachSystem (pkgs: treeFmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);

    devShells = forDevSystems (system: {
      default = import ./nix-support/devshell.nix {
        inherit inputs self;
        hostPlatform = system;
      };
    });

    checks =
      treeFmtEachSystem (pkgs: {
        formatting = treeFmtEval.${pkgs}.config.build.wrapper;
      })
      // forDevSystems (system: {
        pre-commit-check = import ./nix-support/checks.nix {
          inherit inputs self;
          hostPlatform = system;
        };
      });

    templates.default = {
      path = ./.;
      description = "shymega/nixfigs-derived Nix flake starter (mkHost, roles, devshell, formatter, checks)";
    };
  };

  inputs = {
    # This repository, pinned to the branch it was distilled from. Also supplies
    # nixpkgs (via `follows`), overlays, and packages -- see the `overlays` /
    # `packages` outputs above.
    nixfigs = {
      url = "git+ssh://git@github.com/shymega/nixfigs.git?ref=refactor/mk-v";
    
      inputs.git-hooks.follows = "git-hooks";
      inputs.home-manager.follows = "home-manager";
      inputs.sops-nix.follows = "sops-nix";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    nixpkgs.follows = "nixfigs/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager?ref=release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
