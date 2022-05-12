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
# Define root context of this script
#

_my_keys_r=".configs.terminals"
_my_keys_d="${_my_keys_r}.definitions"
_my_term_n="${TERM}"


#
# Assign any terminal-specific settings
#

if [[ -n "${_my_term_n}" ]] && _cfg_is_key "${_my_keys_d}.${TERM}"; then
    _log_action "Configuring terminal environment for '${_my_term_n}' context..."

    if _cfg_is_key "${_my_keys_d}.${TERM}.term"; then
        export TERM="$(_cfg_get_string "${_my_keys_d}.${TERM}.term" "xterm-color")" \
            && _log_action "Assigned and eported new terminal type of '${TERM}' (success)" \
            || _log_action "Assigned and eported new terminal type of '${TERM}' (failure)"
    fi

    _ifs_newlines
    for a in $(_cfg_get_array_assoc "${_my_keys_d}.${TERM}.keys"); do
        k="$(_get_array_key "${a}")"
        v="$(_get_array_val "${a}")"

        bindkey "${v}" "${k}" \
            && _log_action "Bound key for '${_my_term_n}' term env '${k}' => '${v}' (success)" \
            || _log_action "Bound key for '${_my_term_n}' term env '${k}' => '${v}' (failure)"
    done
    _ifs_reset
fi


#
# Assign internal variables
#



#
# Assign home/end bindings
#

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
