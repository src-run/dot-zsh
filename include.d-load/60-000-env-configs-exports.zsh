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
# Loop though exports array and export 'em.
#

for raw in $(_cfg_get_array_assoc 'configs.exports.first'); do
    key="$(_get_array_key "${raw}")"
    val="$(_get_array_val "${raw}")"

    if [[ ${val} == null ]]; then
        export "${key}" &&
            _log_action "Exporting '${key}' variable" ||
            _log_warn "Failed to export '${key}' variable"
    else
        export "${key}"="${val}" &&
            _log_action "Exporting '${key}' variable with '${val}' assignment" ||
            _log_warn "Failed to export '${e}' variable with '${val}' assignment"
    fi
done
