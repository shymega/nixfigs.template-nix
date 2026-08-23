# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
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
