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
# Assign ssh key path
#

SSH_KEY_PATH=$(_cfg_get_string 'configs.ssh.cert_file' "${HOME}/.ssh/id_rsa") \
    && _log_buffer 2 "--- Setting ssh key path to '${SSH_KEY_PATH}'"
