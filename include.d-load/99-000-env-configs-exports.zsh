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

for e in $(_cfg_get_array_values 'configs.exports.variables'); do
    export "${e}" &&
        _log_action "Exporting '${e}' variable" ||
        _log_warn "Failed to export '${e}' variable"
done
