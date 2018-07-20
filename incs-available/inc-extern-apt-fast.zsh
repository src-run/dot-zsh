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
# Source apt-fast shell completion script
#

for f in $(_config_read_array_vals 'extern["apt-fast"].completion_files'); do
    if [[ ! -f "${f}" ]] || [[ ! -r "${f}" ]]; then
        _log_normal 2 \
            "        --- Skipping '${f}' completion file (does not exist)"
        return
    fi

    if [[ ! -r "${f}" ]]; then
        _log_normal 2 \
            "        --- Skipping '${f}' completion file (is not readable)"
        return
    fi

    source "${f}" 2> /dev/null && \
        _log_source 2 2 "Sourcing completions file '${f}'"
done
