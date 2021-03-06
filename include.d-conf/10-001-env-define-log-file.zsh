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
    _cfg_get_string \
        'systems.dot_zsh.logs.path' \
        "${HOME}/.dot-zsh.log"
) && _log_buffer 2 "--- Setting log file to '${_DZ_LOGS_PATH}'"


#
# Remove prior log file and start fresh if over 1000 lines.
#

[[ -f "${_DZ_LOGS_PATH}" ]] && \
    [[ $(cat "${_DZ_LOGS_PATH}" | wc -l) -gt 1000 ]] && \
    rm "${_DZ_LOGS_PATH}" && \
    _log_buffer 2 "--- Purging previous log file contents (over 1000 lines)"


#
# Disable buffering and start outputing now that we have our config.
#

[[ ${_DZ_IO_BUFFERING} -eq -1 ]] && \
    unset _DZ_IO_BUFFERING
