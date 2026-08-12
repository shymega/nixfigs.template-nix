# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
# Per-host module tree, mirroring nixfigs' src/systems/<HOSTNAME>@<system>/.
# Replace this with real hardware/filesystem config before deploying.
{
  networking.hostName = "example-nixos";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
}
