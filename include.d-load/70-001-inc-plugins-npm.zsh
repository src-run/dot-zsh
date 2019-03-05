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
# Add NPM binaries to PATH
#

for f in $(_cfg_get_array_values 'plugins.npm.executable_paths'); do
    _add_env_path_dir "${f}" scripted
done


#
# Setup manpath
#

_DZ_NPM_MANPAGES_PATH="$(_cfg_get_string 'plugins.npm.manset_load_path')"

if [[ -d "${_DZ_NPM_MANPAGES_PATH}" ]]; then
    _DZ_MAN_PATH_ORIGINAL="${MANPATH}"
    unset MANPATH
    _DZ_MAN_PATH_DEFAULTS="$(manpath)"
    _DZ_MAN_PATH_TO_APPLY=""
    _DZ_PATH_DELIMITER=":"

    if [[ ! -z "${_DZ_MAN_PATH_ORIGINAL// }" ]]; then
        for p in "${(ps:$_DZ_PATH_DELIMITER:)_DZ_MAN_PATH_ORIGINAL}"; do
            _DZ_MAN_PATH_TO_APPLY="${p}:${_DZ_MAN_PATH_TO_APPLY}"
        done
    fi

    if [[ ! -z "${_DZ_MAN_PATH_DEFAULTS// }" ]]; then
        for p in "${(ps:$_DZ_PATH_DELIMITER:)_DZ_MAN_PATH_DEFAULTS}"; do
            if [[ ":$_DZ_MAN_PATH_TO_APPLY:" != *":${p}:"* ]]; then
                _DZ_MAN_PATH_TO_APPLY="${p}:${_DZ_MAN_PATH_TO_APPLY}"
            fi
        done
    fi

    if \
        [[ ! -z "${_DZ_NPM_MANPAGES_PATH// }" ]] && \
        [[ ":$_DZ_MAN_PATH_TO_APPLY:" != *":${_DZ_NPM_MANPAGES_PATH}:"* ]];\
        then
        _DZ_MAN_PATH_TO_APPLY="${_DZ_NPM_MANPAGES_PATH}:${_DZ_MAN_PATH_TO_APPLY}"
    fi

    export MANPATH="${_DZ_MAN_PATH_TO_APPLY%?}" && \
        _log_action "Registering '${_DZ_NPM_MANPAGES_PATH}' to 'MANPATH'" || \
        _log_warn "Failed registering '${_DZ_NPM_MANPAGES_PATH}' to 'MANPATH'"

    unset _DZ_MAN_PATH_ORIGINAL
    unset _DZ_MAN_PATH_DEFAULTS
    unset _DZ_MAN_PATH_TO_APPLY
else
    _log_norm 1 \
        "        --- Skipped registering '${_DZ_NPM_MANPAGES_PATH}' to 'MANPATH' (does not exist)"
fi
