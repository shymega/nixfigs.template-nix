# SPDX-FileCopyrightText: 2023-2026 Dom 'shymega' Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: Apache-2.0
# Foundation module every host imports, mirroring nixfigs' src/modules/core.
{username, ...}: {
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  system.stateVersion = "26.05";
}
