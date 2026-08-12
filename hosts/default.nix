# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
# `mkHost`: the same declarative-record-builder pattern as nixfigs' hosts/default.nix,
# trimmed to the inputs this template actually wires up (nixos + home-manager).
{ inputs, ... }:
let
  mkHost =
    {
      type ? "nixos",
      hostname,
      hostPlatform ? "x86_64-linux",
      username ? "user",
      baseModules ? (with inputs; [ sops-nix.nixosModules.default ]),
      hostRoles ? [ ],
      hardwareModules ? [ ],
      extraModules ? [ ],
      embedHm ? true,
    }:
    let
      inherit (inputs.nixpkgs.lib.strings) hasSuffix;
    in
    if type == "nixos" then
      assert (hasSuffix "linux" hostPlatform);
      {
        inherit
          baseModules
          embedHm
          extraModules
          hardwareModules
          hostPlatform
          hostRoles
          hostname
          type
          username
          ;
      }
    else if type == "home-manager" then
      assert username != null;
      {
        inherit type hostPlatform username;
      }
    else
      throw "unknown host type '${type}'";
in
{
  inherit mkHost;
  enabled = inputs.nixpkgs.lib.filesystem.listFilesRecursive ./declarations/enabled.d;
}
