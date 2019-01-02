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
# Assign internal variables
#

_ifs_newlines
for a in $(_cfg_get_array_assoc 'configs.setups.internal_variables'); do
    k="$(_get_array_key "${a}")"
    v="$(_get_array_val "${a}")"

    export ${k}="${v}" \
        && _log_action "Intern assign '${k}' => '${v}' (success)" \
        || _log_action "Intern assign '${k}' => '${v}' (failure)"

done
_ifs_reset
