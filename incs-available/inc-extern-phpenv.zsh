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
# Include phpenv shell helpers.
#

_log_source 2 2 "Initializing phpenv"

_add_env_path_dir "${_DZ_PHPENV_BIN}" scripted && \
    _log_action "Added ${_DZ_PHPENV_BIN} to path"

if [[ -d "${_DZ_PHPENV_ROOT}" ]]; then
    if [[ ! -f "${_DZ_PHPENV_COMPLETIONS}" ]]; then
        _log_warn \
            "Completions for phpenv not found: ${_DZ_PHPENV_COMPLETIONS}"
    else
        source "${_DZ_PHPENV_COMPLETIONS}" 2>/dev/null && \
            _log_source 2 2 "Sourcing file ${_DZ_PHPENV_COMPLETIONS}"
    fi

    eval "$(phpenv init -)" && _log_action "Initializing phpenv"
fi

# EOF
