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
# Set log file path.
#

_DZ_LOGS_PATH=$(
    (
        _cfg_get_string \
            'systems.dot_zsh.logs.fformat' \
            "${HOME}/.dot-zsh.log" | \
        sed -E "s/\{unixtime\}/${_DZ_LOAD_TIME}/"
    ) 2> /dev/null || \
    (
        _cfg_get_string \
            'systems.dot_zsh.logs.fformat' \
            "${HOME}/.dot-zsh.log" | \
        sed -E 's/\{unixtime\}/single/'
    ) 2> /dev/null
) && _log_buffer 2 "--- Setting log file to '${_DZ_LOGS_PATH}'"


#
# Make directory if required
#
mkdir -p "$(dirname "${_DZ_LOGS_PATH}")" 2> /dev/null


#
# Disable buffering and start outputing now that we have our config.
#

[[ ${_DZ_IO_BUFFERING} -eq -1 ]] && \
    unset _DZ_IO_BUFFERING
