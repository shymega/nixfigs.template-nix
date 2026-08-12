# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
# Per-user home-manager tree, mirroring nixfigs' src/homes/<user>@<system>/.
{ username, ... }: {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
