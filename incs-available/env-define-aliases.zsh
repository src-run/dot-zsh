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
# Assign ssh aliases
#

_dotZshSshAliasAssigments


#
# Assign simple aliases
#

for n in "${(@k)D_ZSH_ALIAS_LIST}"; do
    alias $n="${D_ZSH_ALIAS_LIST[$n]}" &&
        _actLog "Alias defined '${n}=\"${D_ZSH_ALIAS_LIST[$n]}\"'"
done

# EOF
