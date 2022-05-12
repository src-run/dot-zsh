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
# Define script path.
#

_DZ_NAME="${(%):-%N}"


#
# Enable shell tracing if environment variable set
#

if [[ -n "${_DZ_TRACE}" ]] && [[ ${_DZ_TRACE} -gt 0 ]]; then
    export PS4='${_DZ_TRACE_PS4:-date[$(date "+%s:%N")] locale[%x:%i|%I] status[%?] state[%_|%^] depth[%e] context[%N] }'

    if [[ ${_DZ_TRACE} -gt 1 ]]; then
        exec 3>&2 2>"${HOME:-/tmp}/.dot-zsh-${$}-trace.log"
    fi

    setopt xtrace prompt_subst
    set -x
fi


#
# Use PCRE regular expressions
#

setopt re_match_pcre


#
# Define root path
#

_DZ_PATH="$(dirname $(realpath "${(%):-%x}"))"
_DZ_IO_BUFF_LINES=()


#
# Define requirements failed to be source function
#

function _failed_required_file_source {
    printf -- \
' !! [FAIL] Unable to locate or source an integral file that is required for'\
' this script to function: "%s" (%s)...\n !! [FAIL] Halting any further'\
' execution of this script due to the unavailability of the aforementioned'\
' dependency requirement!\n'\
' ++ [NOTE] To immediately stop this script, press the CONTROL-C key combo'\
' (this may inadvertently close your terminal/console window in addition to'\
' terminating the script itself, depending on the script invocation method'\
' used when calling this executable)...\n'\
' -- [WAIT] Entered a 5 minute sleep state to preserve any on-screen warnings'\
' or errors; take this time to reference any prior output or logged data to'\
' aid in the diagnosis of this unexpected failure state.\n' "${1}" "${2}"

    sleep 300
    exit 255
}


#
# Attempt to source bootstrapping file...
#

_DZ_IO_BUFF_LINES+=("[---/dot-zsh:----------] --> Boostrapping loader script ...")

for f in ${_DZ_PATH}/include.d-core/*-bootstrap.zsh; do
    if [[ ! -f "${f}" ]]; then
        _failed_required_file_source "${f}" 'it does not exist'
    fi

    source "${f}" \
        && _DZ_IO_BUFF_LINES+=("[---/dot-zsh:----------]     --> Sourcing bootstrap file '$(basename ${f})'") \
        || _failed_required_file_source "${f}" 'it could not be sourced'
done


#
# Inform about script initialization
#

_log_buffer 0 "--> Initializing loader script ..."


#
# Get the start time so we can profile performance start to end.
#

_log_buffer 1 "--- Starting micro-time logged at '${_DZ_LOAD_TIME}'"


#
# Source requires variables assignments and function definitions
#

for f in ${_DZ_PATH}/include.d-core/*-internal.zsh; do
    if [[ ! -f "${f}" ]]; then
        _failed_required_file_source "${f}" 'it does not exist'
    fi

    source "${f}" \
        && _log_buffer 1 "--- Sourcing core file '${f}'" \
        || _failed_required_file_source "${f}" 'it could not be sourced'
done


#
# Validate config scheme version.
#

_log_norm 1 "--> Validating configuration scheme version ..."

if [[ "$(_cfg_get_string 'package.version.schemes')" == "0.2.1" ]]; then
    _log_norm 1 "    --> Validated as '0.2.1' in file '${_DZ_INC_JSON_PATH}' ..."
else
    _log_crit "Failed to validate scheme (using '${_DZ_DEF_JSON_PATH}' instead)!"
    _DZ_INC_JSON_PATH="${_DZ_DEF_JSON_PATH}"
fi


#
# Let the user know we've begun and provide some environment context
#

_buf_definition_list 1 "PROJECT NAME" "${_DZ_BASE}"
_buf_definition_list 1 "PRIMARY AUTHOR" "$(_self_repo_whos)"
_buf_definition_list 1 "RELEASE VERSION" "$(_self_repo_vers)"
_buf_definition_list 1 "GIT REMOTE" "$(_self_repo_repo)"
_buf_definition_list 1 "GIT REFERENCE" "$(_self_repo_tag)"
_buf_definition_list 1 "GIT COMMIT" "$(_self_repo_hash)"
_buf_definition_list 1 "CONFIGURATION FILE" "${_DZ_INC_JSON_PATH}"
_buf_definition_list 1 "LOADER SCRIPT PATH" "$(_self_repo_load)"
_buf_definition_list 1 "PREVIOUS SHELL BIN PATH" "$(_parse_shell_path)"
_buf_definition_list 1 "FOUND ZSH BIN PATH" "$(_parse_zsh_path)"
_buf_definition_list 1 "FOUND ZSH VERSION" "$(_parse_zsh_version)"
_log_norm 3 '--> Loader script environment variables ...'
_log_definition_list


#
# Flushed all buffered lines.
#

_buf_flush_lines


#
# Load our configuration files.
#

_log_norm 1 \
    "--> Loading configuration file(s) from '${_DZ_INC_CONF_PATH}' ..."

for f in ${_DZ_INC_CONF_PATH}/??-???-*.zsh; do
    if [[ ! -f "${f}" ]]; then
        _log_norm 1 "    --> Failed to source config file '$(basename ${f})'"
        continue
    else
        _log_norm 1 "    --> Sourcing config file '$(basename ${f})'"
        source "${f}"
    fi
done


#
# Source all enabled includes by int-prefix order.
#

_log_norm 1 \
    "--> Loading enabled include files(s) from '${_DZ_INC_LOAD_PATH}' ..."

for f in ${_DZ_INC_LOAD_PATH}/??-???-*.zsh; do
    _check_extern_source_file_enabled "${f}" && source "${f}"
done


#
# Disable loading progress and clear screen
#

_cfg_ret_bool 'systems.dot_zsh.show.loading' && \
    _o_progress_close


#
# Generate completion message (can't be done after unsetting vars/functions)
#

_cfg_ret_bool 'systems.dot_zsh.show.summary' && \
    _DZ_DONE_MESSAGE="$(_load_summary_display)\n"


#
# Cleanup all internal variables and functions (unset them).
#

_log_norm 1 "--> Performing final cleanup pass ..."
_log_action "Unsetting ${#_DZ_UNSET_VS[@]} internal variables ..." 1
_log_action "Unsetting ${#_DZ_UNSET_FS[@]} internal functions ..." 1
_log_norm 1 "--> Completed all operations ..."

for v in ${_DZ_UNSET_VS[@]}; do
    eval "unset ${v}" 2> /dev/null
done

for f in ${_DZ_UNSET_FS[@]}; do
    eval "unset -f ${f}" 2> /dev/null
done

unset _DZ_UNSET_VS
unset _DZ_UNSET_FS


#
# Write completion message if available and then unset it.
#

if [[ ! -z "${_DZ_DONE_MESSAGE}" ]]; then
    echo -en "${_DZ_DONE_MESSAGE}"
    unset _DZ_DONE_MESSAGE
fi

# BEGIN SNIPPET: Platform.sh CLI configuration
HOME=${HOME:-'/home/rmf'}
export PATH="$HOME/"'.platformsh/bin':"$PATH"
if [ -f "$HOME/"'.platformsh/shell-config.rc' ]; then . "$HOME/"'.platformsh/shell-config.rc'; fi # END SNIPPET

#eval $(ssh-agent &> /dev/null)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
