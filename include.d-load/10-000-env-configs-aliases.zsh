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
# Log ssh connection alias assignment section
#

_log_action "Setting up configured aliases (ssh connections)..."


#
# Assign ssh aliases
#

_aliases_setup_ssh_connections


#
# Log basic command alias assignment section
#

_log_action "Setting up configured aliases (basic commands)..."


#
# Assign simple aliases
#


# set ifs variable to newlines
_ifs_newlines

# loop over configured simple command aliases
for a in $(_cfg_get_array_assoc 'configs.aliases.set_simple_commands'); do
    k="$(_get_array_key "${a}")"
    v="$(_get_array_val "${a}")"

    if _cfg_ret_bool 'configs.aliases.new_simple_commands' 'true' && alias | grep -E "^${k}=" &> /dev/null; then
        unalias "${k}" 2> /dev/null \
            && _log_action "Removed prior alias: '${k}'" 3 \
            || _log_action "Failed alias remove: '${k}'" 3
    fi

    alias "${k}"="${v}" 2> /dev/null \
        && _log_action "Defined alias value: '${k}' => '${v}'" 3 \
        || _log_action "Failed alias assign: '${k}' => '${v}'" 3
done

# reset ifs variable to prior value
_ifs_reset
