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
# Export our default gnupg key and tty
#

v=$(_cfg_get_string 'plugins.gnupg.secret_key')

if [[ ! -z "${v}" ]]; then
    GPGKEY="${v}" && \
        _log_action "Assigned gpg key to '${v}'" || \
        _log_warn "Failed to assign gpg key to '${v}'"
else
    _log_norm 1 \
        "        --- Skipping gpg key assignment (missing configuration)"
fi

v=$(_cfg_get_string 'plugins.gnupg.export_tty')

if [[ ! -z "${v}" ]]; then
    GPG_TTY="${v}" && \
        _log_action "Assigned gpg tty to '${v}'" || \
        _log_warn "Failed to assign gpg tty to '${v}'"
else
    _log_norm 1 \
        "        --- Skipping gpg tty assignment (missing configuration)"
fi
