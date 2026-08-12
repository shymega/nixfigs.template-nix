# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
# Same shape as nixfigs' nix-support/roles.nix: a closed vocabulary of roles,
# plus a `checkRoles` helper for gating modules on them. Trim/extend `roles`
# to taste; hosts opt into a subset via `hostRoles` in mkHost (see hosts/).
rec {
  roles = [
    "minimal"
    "personal"
    "server"
    "work"
    "workstation"
  ];
  utils = rec {
    checkRoles =
      targetRoles: configOrHostRoles:
      let
        checkRole = role: builtins.elem role roles;

        rolesList = if builtins.isList targetRoles then targetRoles else [ targetRoles ];

        isConfig = builtins.isAttrs configOrHostRoles;

        enabledRoles = if isConfig then configOrHostRoles.nixfigs.meta.rolesEnabled else configOrHostRoles;
      in
      (builtins.any checkRole rolesList)
      && (builtins.any (role: builtins.elem role enabledRoles) rolesList);
  };
}
