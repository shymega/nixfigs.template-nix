# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
{
  hostPlatform,
  inputs,
  lib ? inputs.nixpkgs.lib,
  self,
  ...
}:
inputs.git-hooks.lib.${hostPlatform}.run {
  src = lib.cleanSource "${self}/.";

  hooks = {
    nixfmt.enable = true;
    statix.enable = true;
    deadnix.enable = true;

    shellcheck.enable = true;
    shfmt.enable = true;

    yamlfmt.enable = true;
    check-yaml.enable = true;
    check-json.enable = true;

    markdownlint.enable = true;

    check-added-large-files.enable = true;
    check-case-conflicts.enable = true;
    check-merge-conflicts.enable = true;
    detect-private-keys.enable = true;
  };
}
