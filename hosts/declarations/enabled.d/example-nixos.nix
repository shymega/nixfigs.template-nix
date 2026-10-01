# SPDX-FileCopyrightText: 2023-2026 Dom 'shymega' Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: Apache-2.0
# Drop one file per host in this directory to enable it; `hosts/default.nix`
# picks up everything under `enabled.d/` automatically (mirrors nixfigs'
# hosts/declarations/enabled.d convention).
{mkHost, ...}:
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
