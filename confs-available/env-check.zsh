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
# Enable shell-debugging if ${DEBUG} var is set to true or 1.
#

if [[ ${DEBUG} -eq 1 ]] || [[ ${DEBUG} == "true" ]]; then
    _log_buffer 2 \
        "--- Enabling debug mode with 'set -x' (set from \${DEBUG} var)"
    set -x
fi


#
# Enable shell-debugging if enabled in config file.
#

_config_return_boolean 'internal.dot_zsh_settings.debug' && \
    _log_buffer 2 \
        "--- Enabling debut mode with 'set -x' (set from config file)" && \
    set -x
