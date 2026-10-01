# SPDX-FileCopyrightText: 2023-2026 Dom 'shymega' Rodriguez <shymega@shymega.org.uk>
#
# SPDX-License-Identifier: Apache-2.0
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
