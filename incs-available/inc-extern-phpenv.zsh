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

_incLog 2 2 "Initializing phpenv"

_dotZshPathVariableAddition "${_DOT_ZSH_PHPENV_BIN}" scripted && \
    _actLog "Added ${_DOT_ZSH_PHPENV_BIN} to path"

if [[ -d "${_DOT_ZSH_PHPENV_ROOT}" ]]; then
    if [[ ! -f "${_DOT_ZSH_PHPENV_COMPLETIONS}" ]]; then
        _dzsh_warning \
            "Completions for phpenv not found: ${_DOT_ZSH_PHPENV_COMPLETIONS}"
    else
        source "${_DOT_ZSH_PHPENV_COMPLETIONS}" 2>/dev/null && \
            _incLog 2 2 "Sourcing file ${_DOT_ZSH_PHPENV_COMPLETIONS}"
    fi

    eval "$(phpenv init -)" && _actLog "Initializing phpenv"
fi

# EOF
