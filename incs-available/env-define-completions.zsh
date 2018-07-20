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
# Register our custom completions.
#

for p in $(_config_read_array_vals 'define.completions.paths'); do
    if [[ ! -d "${p}" ]]; then
        continue
    fi

    fpath=("${p}" ${fpath}) && \
        _log_action "Registering '${p}' in 'fpath' environment variable"
done


autoload -U compinit && compinit &&
    _log_action "Auto-loading and initializing 'compinit'"
