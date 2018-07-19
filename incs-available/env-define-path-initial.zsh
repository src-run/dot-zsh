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
    [[ ! -z ${_DZ_PATH_ADDITIONS_LIST} ]] && \
    [[ $_DZ_PATH_ADDITIONS_LIST[(I)$_DZ_PATH_ADDITIONS_LIST[-1]] -gt 0 ]];
    then
    for p in "${(@k)_DZ_PATH_ADDITIONS_LIST}"; do
        _add_env_path_dir "${p}" default
    done
fi


#
# Add custom directories from user-file to environment PATH variable (if exists)
#

if \
    [[ ! -z ${_DZ_PATH_ADDITIONS_FILE} ]] && \
    [[ -r "${_DZ_PATH_ADDITIONS_FILE}" ]]; \
    then
    while read p; do
        _add_env_path_dir "${p}" custom
    done <"${_DZ_PATH_ADDITIONS_FILE}"
fi

# EOF
