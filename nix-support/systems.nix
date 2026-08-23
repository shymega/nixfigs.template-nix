# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
# Centralized system definitions, mirroring nixfigs' nix-support/systems.nix.
{
  inputs,
  lib ? inputs.nixpkgs.lib,
  ...
}: {
  linuxSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  darwinSystems = [
    "aarch64-darwin"
  ];

  defaultSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  treefmtSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  devshellSystems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  checkSystems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  forEachSystem = systems: f: lib.genAttrs systems f;

  forDefaultSystems = f:
    lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ]
    f;

  forDevSystems = f:
    lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ]
    f;

  isLinux = system: lib.hasSuffix "-linux" system;
  isDarwin = system: lib.hasSuffix "-darwin" system;
}
