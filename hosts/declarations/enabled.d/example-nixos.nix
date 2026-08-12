# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
# Drop one file per host in this directory to enable it; `hosts/default.nix`
# picks up everything under `enabled.d/` automatically (mirrors nixfigs'
# hosts/declarations/enabled.d convention).
{ mkHost, ... }:
mkHost {
  type = "nixos";
  hostname = "example-nixos";
  hostPlatform = "x86_64-linux";
  username = "example-user";
  hostRoles = [
    "workstation"
    "personal"
  ];
}
