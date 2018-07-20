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
    _config_read_string \
        'internal.dot_zsh_settings.log_path' \
        "${HOME}/.dot-zsh.log"
) && _log_buffer 2 "--- Setting log file to '${_DZ_LOGS_PATH}'"


#
# Remove prior log file and start fresh.
#

[[ -f "${_DZ_LOGS_PATH}" ]] &&
    rm "${_DZ_LOGS_PATH}" && \
    _log_buffer 2 "--- Purging previous log file contents"


#
# Disable buffering and start outputing now that we have our config.
#

[[ ${_DZ_STIO_BUFF} -eq -1 ]] && \
    unset _DZ_STIO_BUFF


# EOF
