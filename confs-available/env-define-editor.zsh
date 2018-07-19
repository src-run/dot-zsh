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
# Set our default editor depending on connection type.
#

if [[ -n ${SSH_CONNECTION} ]]; then
    EDITOR_NAME=$(
        _try_read_conf_string 'internal.general_settings.editor.ssh' 'nano'
    )
else
    EDITOR_NAME=$(
        _try_read_conf_string 'internal.general_settings.editor.loc' 'subl'
    )
fi

EDITOR=$(which ${EDITOR_NAME})

if [[ $? -ne 0 ]]; then
    _log_buffer 2 "--- Failed to resolve editor absolute path for '${EDITOR}'"
fi

_log_buffer 2 "--- Setting default editor to '${EDITOR}'"


# EOF
