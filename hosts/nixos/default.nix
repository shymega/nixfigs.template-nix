# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
{
  inputs,
  self,
  ...
}:
let
  genConfiguration =
    hostname:
    {
      baseModules,
      embedHm,
      extraModules,
      hardwareModules,
      hostPlatform,
      hostRoles,
      username,
      ...
    }:
    inputs.nixpkgs.lib.nixosSystem {
      pkgs = self.genPkgs hostPlatform;
      modules =
        baseModules
        ++ [
          "${self}/src/systems/${hostname}@${hostPlatform}"
          "${self}/src/modules/core"
        ]
        ++ extraModules
        ++ hardwareModules
        ++ (inputs.nixpkgs.lib.optionals embedHm [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupFileExtension = "hm.bak";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} = "${self}/src/homes/${username}@${hostPlatform}";
              extraSpecialArgs = {
                inherit
                  hostPlatform
                  hostRoles
                  hostname
                  inputs
                  self
                  username
                  ;
              };
            };
          }
        ]);
      specialArgs = {
        system = hostPlatform;
        inherit
          hostPlatform
          hostRoles
          hostname
          inputs
          self
          username
          ;
      };
    };
in
inputs.nixpkgs.lib.mapAttrs genConfiguration (
  inputs.nixpkgs.lib.filterAttrs (_: host: host.type == "nixos") self.hosts
)
