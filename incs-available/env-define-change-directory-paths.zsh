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

for dir in $(_config_read_array_vals 'define["change-directory-paths"].paths'); do
    if [[ ! -d "${dir}" ]]; then
        continue
    fi

    cdpath+=( "${dir}" ) && \
        _log_action "Registering '${dir}' in 'cdpath' environment variable" ||
        _log_warn "Failed to add '${dir}' to 'cdpath' environment variable"
done

# EOF
