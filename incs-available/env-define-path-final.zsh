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
    [[ ! -z "${_DZ_PATH_SCRIPTED_FILE}" ]] && \
    [[ -r "${_DZ_PATH_SCRIPTED_FILE}" ]]; \
    then
    while read p; do
        _add_env_path_dir "${p}" custom
    done <"${_DZ_PATH_SCRIPTED_FILE}"
fi

_clean_env_path_dir_temp

# EOF
