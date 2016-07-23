#!/usr/bin/env zsh

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#


#
# Define our list of variable to export.
#

typeset -a D_ZSH_EXPORTS

D_ZSH_EXPORTS=(ZSH PATH LANG EDITOR SSH_KEY_PATH)


#
# Loop though exports array and export 'em.
#

for e in "${D_ZSH_EXPORTS[@]}"; do
  export "${e}" && _incLog 2 3 "Variable export '${e}'"
done

# EOF
