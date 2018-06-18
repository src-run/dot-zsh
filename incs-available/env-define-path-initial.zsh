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
# Add default directories to environment PATH variable
#

if \
    [[ ! -z ${D_ZSH_PATH_ADDITIONS_LIST} ]] && \
    [[ $D_ZSH_PATH_ADDITIONS_LIST[(I)$D_ZSH_PATH_ADDITIONS_LIST[-1]] -gt 0 ]];\
    then
    for p in "${(@k)D_ZSH_PATH_ADDITIONS_LIST}"; do
        _dotZshPathVariableAddition "${p}" default
    done
fi


#
# Add custom directories from user-file to environment PATH variable (if exists)
#

if \
    [[ ! -z ${D_ZSH_PATH_ADDITIONS_FILE} ]] && \
    [[ -r "${D_ZSH_PATH_ADDITIONS_FILE}" ]]; \
    then
    while read p; do
        _dotZshPathVariableAddition "${p}" custom
    done <"${D_ZSH_PATH_ADDITIONS_FILE}"
fi

# EOF
