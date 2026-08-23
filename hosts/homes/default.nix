# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
{
  inputs,
  self,
  ...
}: let
  inherit (inputs.home-manager.lib) homeManagerConfiguration;
  genConfiguration = _hostname: {
    hostPlatform,
    username,
    ...
  }:
    homeManagerConfiguration {
      pkgs = self.genPkgs hostPlatform;
      modules = ["${self}/src/homes/${username}@${hostPlatform}"];
      extraSpecialArgs = {
        inherit
          inputs
          self
          username
          hostPlatform
          ;
      };
    };
in
  inputs.nixpkgs.lib.mapAttrs genConfiguration (
    inputs.nixpkgs.lib.filterAttrs (_: host: host.type == "home-manager") self.hosts
  )
