#!/usr/bin/env zsh

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#


SSH_KEY_PATH=$(
    _try_read_conf_string \
        'internal.general_settings.ssh.key_path' \
        "${HOME}/.ssh/id_rsa"
) && _log_buffer 2 "--- Setting ssh key path to '${SSH_KEY_PATH}'"
