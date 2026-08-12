# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
{
  self,
  hostPlatform,
  pkgs ? self.genPkgs hostPlatform,
  ...
}:
pkgs.mkShell {
  name = "shy-nixfigs";

  nativeBuildInputs = with pkgs; [
    deploy-rs
    jq
    nil
    nix-output-monitor
    nix-tree
    pre-commit
    statix
  ];

  inherit (self.checks.${hostPlatform}.pre-commit-check) shellHook;
  buildInputs = self.checks.${hostPlatform}.pre-commit-check.enabledPackages;
}
