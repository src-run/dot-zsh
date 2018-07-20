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
# Setup golang environment
#

v="$(_config_read_string 'extern.golang.mortal_root_path')"

if [[ -d "${v}" ]]; then
    export GOROOT="${v}" && \
        _log_action "Assigning 'GOROOT' to '${v}'" || \
        _log_warn "Failed assigning 'GOROOT' to '${v}'"
else
    _log_normal 1 \
        "        --- Skipping 'GOROOT' assignment '${v}' (does not exist)"
fi

_add_env_path_dir "$(_config_read_string 'extern.golang.mortal_exec_path')" scripted
