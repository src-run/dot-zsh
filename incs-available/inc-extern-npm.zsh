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

_dotZshPathVariableAddition "${HOME}/node_modules/.bin/" scripted
_dotZshPathVariableAddition "${D_ZSH_NPM_PACKAGES_PATH}/bin" scripted


#
# Setup manpath
#

if [[ -d "${D_ZSH_NPM_MANPAGES_PATH}" ]]; then
    D_ZSH_MAN_PATH_ORIGINAL="${MANPATH}"
    unset MANPATH
    D_ZSH_MAN_PATH_DEFAULTS="$(manpath)"
    D_ZSH_MAN_PATH_TO_APPLY=""
    D_ZSH_PATH_DELIMITER=":"

    if [[ ! -z "${D_ZSH_MAN_PATH_ORIGINAL// }" ]]; then
        for p in "${(ps:$D_ZSH_PATH_DELIMITER:)D_ZSH_MAN_PATH_ORIGINAL}"; do
            D_ZSH_MAN_PATH_TO_APPLY="${p}:${D_ZSH_MAN_PATH_TO_APPLY}"
        done
    fi

    if [[ ! -z "${D_ZSH_MAN_PATH_DEFAULTS// }" ]]; then
        for p in "${(ps:$D_ZSH_PATH_DELIMITER:)D_ZSH_MAN_PATH_DEFAULTS}"; do
            if [[ ":$D_ZSH_MAN_PATH_TO_APPLY:" != *":${p}:"* ]]; then
                D_ZSH_MAN_PATH_TO_APPLY="${p}:${D_ZSH_MAN_PATH_TO_APPLY}"
            fi
        done
    fi

    if \
        [[ ! -z "${D_ZSH_NPM_MANPAGES_PATH// }" ]] && \
        [[ ":$D_ZSH_MAN_PATH_TO_APPLY:" != *":${D_ZSH_NPM_MANPAGES_PATH}:"* ]];\
        then
        D_ZSH_MAN_PATH_TO_APPLY="${D_ZSH_NPM_MANPAGES_PATH}:${D_ZSH_MAN_PATH_TO_APPLY}"
    fi

    export MANPATH="${D_ZSH_MAN_PATH_TO_APPLY%?}"

    unset D_ZSH_MAN_PATH_ORIGINAL
    unset D_ZSH_MAN_PATH_DEFAULTS
    unset D_ZSH_MAN_PATH_TO_APPLY
fi

# EOF
