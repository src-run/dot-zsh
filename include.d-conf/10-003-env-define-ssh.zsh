#!/usr/bin/env bash

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#


#
# build ssh conf key for context
#

_make_ssh_cfg_key() {
    local key="configs.ssh"
    local add=("${@}")

    for a in "${add[@]}"; do
        key+=".${a}"
    done

    printf '%s' "${key}"
}


#
# build ssh-add options from config
#

_get_ssh_agent_eval_conf_raw() {
    _cfg_get_string "$(_make_ssh_cfg_key 'exe_agent')" 'ssh-agent'
}


#
# build ssh-add options from config
#

_get_ssh_agent_eval_run_code() {
    eval "$(_get_ssh_agent_eval_conf_raw)" 2> /dev/null
}


#
# parse ssh-add keys array entry for key path and return non-zero if key is disabled
#

_parse_ssh_add_array_item_combined_key_val() {
    local vals="${1}"
    local path
    local used

    # parse combined raw array val/key string
    path="$(_get_array_key "${vals}")"
    used="$(_get_array_val "${vals}")"

    # output key path regardless of enabled state
    printf '%s' "${path}"

    # return non-zero if key is not enabled
    if [[ ${used} != 'true' ]]; then
      return 1
    fi
}


#
# build ssh-add options from config
#

_build_ssh_add_opts() {
    local opts_def=('-q' '-c')
    local opts_cfg=()

    # loop through configured opts and append to local opts array
    for o in $(_cfg_get_array_values "$(_make_ssh_cfg_key 'load_opts')"); do
        opts_cfg+=("${o}")
    done

    # assign default opts if none configured via configuration file
    if [[ ${#opts_cfg[@]} -eq 0 ]]; then
        opts_cfg=("${opts_def[@]}")
    fi

    # output opts as space-separated single-line string for direct usage in cmd call
    printf '%s ' "${opts_cfg[@]}"
}


#
# call ssh-add command for passed ssh key file
#

_call_ssh_add_cmd() {
    local key_iden="${1}"
    local key_name
    local key_path
    local ssh_exec

    if ! _cfg_ret_bool "$(_make_ssh_cfg_key 'load_keys' "${key_iden}" 'key_used')"; then
        return
    fi

    if ! _cfg_is_null "$(_make_ssh_cfg_key 'load_keys' "${key_iden}" 'alt_name')"; then
        key_name="$(_try_cfg_get_val "$(_make_ssh_cfg_key 'load_keys' "${1}" 'alt_name')" "${key_iden}")"
    else
        key_name="${ket_iden}"
    fi

_log_action "CFG-KEY[$(_make_ssh_cfg_key 'load_keys' "${key_iden}" 'key_path')]"
    key_path="$(_cfg_get_string "$(_make_ssh_cfg_key 'load_keys' "${key_iden}" 'key_path')")"
    key_path="$(_cfg_get_string configs.ssh.load_keys.${key_iden}.key_path)"

    _log_action "Adding key ${key_iden}: ${key_path}/${key_name}..."
return

    # attempt to resolve absolute path to ssh-add command
    if ! ssh_add_bin_path="$(command -v ssh-add)"; then
        ssh_add_bin_path='ssh-add'
    fi

    # parse raw combined config array key/val and return if key is detected as disabled
    if ! ssh_add_key_file="$(_parse_ssh_add_array_item_combined_key_val "${ssh_key_raw_vals}")"; then
        _log_action "Skipping ssh-add key operation for '${ssh_add_key_file}' (disabled in configuration)..."
        return
    fi

    # check for existance of key file and return if it does not exist
    if [[ ! -f "${ssh_add_key_file}" ]]; then
        _log_action "Skipping ssh-add key operation for '${ssh_add_key_file}' (key file does not exist)..."
        return
    fi

    # call ssh-add cmd and output error message on non-zero return
    # intentionally ignore "quote to avoid word splitting" syntax check error, as this is intentionally word-split
    # shellcheck disable=SC2046
    if ! ${ssh_add_bin_path} $(_build_ssh_add_opts) "${ssh_add_key_file}" 2> /dev/null; then
        _log_warn "Registration failure for ssh key: '${ssh_add_key_file}' (command exited with non-zero status code)..."
        return 1
    fi

    # output success message if we made it this far
    _log_action "Registration success for ssh key: '${ssh_add_key_file}'..."
}


#
# check if PID actually exists
#

_has_ssh_agent_pid_real() {
    local agent_pid="${1}"
    local found_cmd

    # if empty arg passed OR ps command returns non-zero for pid OR resulting command from ps is not ssh-agent
    if [[ -z ${agent_pid} ]] || ! found_cmd="$(ps -o command= -p "${agent_pid}" 2> /dev/null)" || [[ ${found_cmd} != 'ssh-agent' ]]; then
        return 1
    fi
}


#
# get existing ssh-agent PID or return non-zero if not found
#

_get_ssh_agent_pid() {
    local agent_env_pid="${SSH_AGENT_PID}"
    local agent_cmd_pid

    if ! _has_ssh_agent_pid_real "${agent_env_pid}"; then
        :
        #_env_ssh_agent_pid_clear
    fi

    if ! agent_cmd_pid="$(pgrep -u "${USER}" ssh-agent)" && ! _has_ssh_agent_pid_real "${agent_cmd_pid}"; then
        return 1
    fi

    printf '%s' "${agent_cmd_pid}"
}


#
# check for existing ssh-agent pid
#

_has_ssh_agent_pid() {
    if ! _get_ssh_agent_pid &> /dev/null; then
        return 1
    fi
}


#
# ensure existing ssh-agent PID is exported globally
#

_env_ssh_agent_pid_clear() {
    # unset existing ssh-agent env var (if it exists)
    unset SSH_AGENT_PID &> /dev/null
}


#
# ensure existing ssh-agent PID is exported globally
#

_env_ssh_agent_pid_export() {
    local agent_pid="$(_get_ssh_agent_pid)"

    # if ssh-agent env var is empty and an agent was found OR is the env var does not match the found agent PID
    if ([[ -z ${SSH_AGENT_PID} ]] && [[ -n ${agent_pid} ]]) || ([[ ${SSH_AGENT_PID} != ${agent_pid} ]]); then
        # unset existing ssh-agent env var (if it exists)
        _env_ssh_agent_pid_clear

        # assign the resolved ssh-agent pid to a new global and exported env var
        typeset -gx SSH_AGENT_PID="${agent_pid}"
    fi
}


#
# check for configuration state of ssh-agent and return if disabled
#

if ! _cfg_ret_bool "$(_make_ssh_cfg_key 'use_agent')"; then
    _log_action 'Skipping initialization of ssh-agent command and ssh-add key setup (disabled in configuration)...'
    return
fi


#
# check for existing ssh-agent instance via env var and return if already exists
#

if _has_ssh_agent_pid && _has_ssh_agent_pid_real "$(_get_ssh_agent_pid)"; then
    _log_action "Found existing ssh-agent instance as PID '$(_get_ssh_agent_pid)' (skipping additional setup)..."
    _env_ssh_agent_pid_export
    return
fi

#
# evaluate ssh-agent code
#
_has_ssh_agent_pid
_log_action "PID-HAS:$?"
_log_action "PID-GET:$(_get_ssh_agent_pid)"
_has_ssh_agent_pid_real "$(_get_ssh_agent_pid)"
_log_action "PID-HAS-REAL:$?"
_log_action "[DEBUG] Resolved ssh-agent process identifier: '$(_get_ssh_agent_pid)'..."

eval "$(_get_ssh_agent_eval_run_code)" &> /dev/null && _env_ssh_agent_pid_export

_log_action "[DEBUG] Resolved ssh-agent process identifier: '$(_get_ssh_agent_pid)'..."
_has_ssh_agent_pid
_log_action "PID-HAS:$?"
_log_action "PID-GET:$(_get_ssh_agent_pid)"
_has_ssh_agent_pid_real "$(_get_ssh_agent_pid)"
_log_action "PID-HAS-REAL:$?"

if _get_ssh_agent_pid &> /dev/null; then
    _log_action "Started new ssh-agent instance as PID '$(_get_ssh_agent_pid)'..."
else
    _log_warn "Failure encountered during ssh-agent code evaluation of '$(_get_ssh_agent_eval_conf_raw)'..."
    return
fi

#
# loop through configured ssh keys and add using ssh-add
#

for n in $(_cfg_get_array_keys "$(_make_ssh_cfg_key 'load_keys')"); do
    _call_ssh_add_cmd "${n}"
done
