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
    _DZ_EDITOR_NAME=$(
        _cfg_get_string 'configs.editor.external_session' 'nano'
    )
else
    _DZ_EDITOR_NAME=$(
        _cfg_get_string 'configs.editor.internal_session' 'subl'
    )
fi


#
# Resolve editor path using "which".
#

_DZ_EDITOR_PATH="$(which "${_DZ_EDITOR_NAME}" 2> /dev/null)"


#
# Assign editor if "which" was successful or display failure message.
#

if [[ $? -eq 0 ]]; then
    EDITOR="${_DZ_EDITOR_PATH}" && \
        _log_buffer 2 "--- Setting default editor to '${_DZ_EDITOR_PATH}'"
else
    _log_buffer 2 "--- Failed to resolve editor path for '${_DZ_EDITOR_NAME}'"
fi
