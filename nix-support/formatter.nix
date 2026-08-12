# SPDX-FileCopyrightText: 2026 Dom Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: GPL-3.0-only
_: {
  projectRootFile = "flake.nix";

  programs = {
    alejandra.enable = true;
    jsonfmt.enable = true;
    mdformat.enable = true;
    shellcheck.enable = true;
    shfmt.enable = true;
    statix.enable = true;
    yamlfmt.enable = true;
  };
}
