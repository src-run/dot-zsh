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
# Log nvm environment setup actions
#

_log_action "Assigning nvm variables"


#
# Assign nvm dir variable
#

if [[ -z "${NVM_DIR}" ]]; then
    NVM_DIR="$(_log_assignment NVM_DIR "$(
        _cfg_get_string 'plugins.nvm.mortal_root_path'
    )")" && _file_out_buffer
fi


#
# Unset nvm dir variable if path does not exist or is not readable
#

if [[ ! -d "${NVM_DIR}" ]] || [[ ! -r "${NVM_DIR}" ]]; then
    unset NVM_DIR 2> /dev/null \
        && _log_action "Unset variable 'NVM_DIR' with value '${NVM_DIR}' (invalid path)" 3
fi


#
# Log installation of required nvm versions
#

_log_action "Requiring nvm releases"


#
# Require nvm versions
#

for k in $(_cfg_get_array_keys 'plugins.nvm.define_v_install'); do
    _NVM_VER="$(
        _cfg_get_string "plugins.nvm.define_v_install[${k}].install_vers_nvm" 'undefined'
    )"

    _NVM_OPT=($(sed -E 's/[ ]+/ /g' 2> /dev/null <<< "$(
        _cfg_get_string "plugins.nvm.define_v_install[${k}].install_opts_use" ''
    )"))

    _cfg_ret_bool "plugins.nvm.define_v_install[${k}].install_opts_add" 'false' \
        && _NVM_OPT+=('--lts')

    if [[ -z "${_NVM_VER}" ]] || [[ 'undefined' == "${_NVM_VER}" ]]; then
        _log_action "Version string for nvm config entry ${k} invalid..." 3 \
            && continue
    fi

    if ! which nvm &> /dev/null; then
        _log_action "Unable to locate nvm binary..." 3 \
            && continue
    fi

    if ! nvm ls-remote "${_NVM_VER}" ${_NVM_OPT[@]} &> /dev/null; then
        _log_action "Remote could not locate nvm version: '${_NVM_VER}'" 3 \
            && continue
    fi

    if _cfg_ret_bool "plugins.nvm.define_v_install[${k}].removes_existing" 'false'; then
        nvm uninstall "${_NVM_VER}" &> /dev/null \
            && _log_action "Removed prior nvm version: '${_NVM_VER}'" 3 \
            || _log_action "Failed prior nvm removal: '${_NVM_VER}'" 3
    fi

    if nvm ls ${_NVM_VER} &>/dev/null; then
        _log_action "Found prior nvm installation: '${_NVM_VER}'" 3 \
            && continue
    fi

    _cfg_ret_bool "plugins.nvm.define_v_install[${k}].install_with_npm" 'false' \
        && _NVM_OPT+=('--latest-npm')

    nvm install "${_NVM_VER}" ${_NVM_OPT[@]} &> /dev/null \
            && _log_action "Installing nvm version: '${_NVM_VER}'" 3 \
            || _log_action "Failed nvm installation: '${_NVM_VER}'" 3
done


#
# Log assignment of nvm aliases
#

_log_action "Assigning nvm aliases for nvm versions"


#
# Assign nvm version aliases
#

_ifs_newlines
for a in $(_cfg_get_array_assoc 'plugins.nvm.define_v_aliases'); do
    k="$(_get_array_key "${a}")"
    v="$(_get_array_val "${a}")"

    if nvm alias "${k}" &> /dev/null; then
        if _cfg_ret_bool 'plugins.nvm.remove_v_aliases'; then
            nvm unalias "${k}" &> /dev/null
        else
            _log_action "Found existing nvm alias: '${k}' => '${v}'" 3 \
                && continue
        fi
    fi

    nvm alias "${k}" "${v}" &> /dev/null \
        && _log_action "Defined nvm alias: '${k}' => '${v}'" 3 \
        || _log_action "Failure defininf nvm alias: '${k}' => '${v}'" 3
done
_ifs_reset


#
# Source nvm shell completion scripts
#

for f in $(_cfg_get_array_values 'plugins.nvm.completion_files'); do
    if [[ ! -f "${f}" ]] || [[ ! -r "${f}" ]]; then
        _log_normal 2 \
            "        --- Skipping '${f}' completion file (does not exist)"
        return
    fi

    if [[ ! -r "${f}" ]]; then
        _log_normal 2 \
            "        --- Skipping '${f}' completion file (is not readable)"
        return
    fi

    source "${f}" 2> /dev/null && \
        _log_source 2 2 "Sourcing completions file '${f}'"
done
