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
# Add script requested directories from temporary-file to environment PATH variable (if exists)
#

if \
    [[ ! -z "${D_ZSH_PATH_SCRIPTED_FILE}" ]] && \
    [[ -r "${D_ZSH_PATH_SCRIPTED_FILE}" ]]; \
    then
    while read p; do
        _dotZshPathVariableAddition "${p}" custom
    done <"${D_ZSH_PATH_SCRIPTED_FILE}"
fi

_dotZshPathVariableAdditionRequestCleanup

# EOF
