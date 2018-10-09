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
# Assign ssh aliases
#

_aliases_setup_ssh_connections


#
# Assign simple aliases
#

_ifs_newlines
for a in $(_config_read_array_assoc 'configs.aliases.set_simple_cmds'); do
    k="$(_get_array_key "${a}")"
    v="$(_get_array_val "${a}")"
    alias ${k}="${v}" &&
        _log_action "Alias defined '${k}' => '${v}'"
done
_ifs_reset
