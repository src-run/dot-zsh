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

_aliases_setup_ssh_connections


#
# Assign simple aliases
#

for n in "${(@k)_DZ_ALIAS_LIST}"; do
    alias $n="${_DZ_ALIAS_LIST[$n]}" &&
        _log_action "Alias defined '${n}=\"${_DZ_ALIAS_LIST[$n]}\"'"
done

# EOF
