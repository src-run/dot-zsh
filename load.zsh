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
    printf 'Failed to locate a required file: "%s" (%s)...' "${1}" "${2}"
    sleep 30
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

_log_normal 1 "--> Validating configuration scheme version ..."

if [[ "$(_cfg_get_string 'package.version.schemes')" == "0.2.1" ]]; then
    _log_normal 1 "    --> Validated as '0.2.1' in file '${_DZ_INC_JSON_PATH}' ..."
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
_log_normal 3 '--> Loader script environment variables ...'
_log_definition_list

#
# Flushed all buffered lines.
#

_buf_flush_lines


#
# Load our configuration files.
#

_log_normal 1 \
    "--> Loading configuration file(s) from '${_DZ_INC_CONF_PATH}' ..."

for f in ${_DZ_INC_CONF_PATH}/??-???-*.zsh; do
    [[ ! -f "${f}" ]] && \
        _log_normal 1 \
            "    --> Failed to source config file '$(basename ${f})'" && \
        continue

    _log_normal 1 "    --> Sourcing config file '$(basename ${f})'" && \
        source "${f}"
done

#
# Source all enabled includes by int-prefix order.
#

_log_normal 1 \
    "--> Loading enabled include files(s) from '${_DZ_INC_LOAD_PATH}' ..."

for f in ${_DZ_INC_LOAD_PATH}/??-???-*.zsh; do
    _check_extern_source_file_enabled "${f}" && source "${f}"
done


#
# Disable loading progress and clear screen
#

_cfg_ret_bool 'systems.dot_zsh.show.loading' && \
    _disable_loading


#
# Generate completion message (can't be done after unsetting vars/functions)
#

_cfg_ret_bool 'systems.dot_zsh.show.summary' && \
    _DZ_DONE_MESSAGE="$(_show_summary)"


#
# Cleanup all internal variables and functions (unset them).
#

_log_normal 1 "--> Performing final cleanup pass ..."
_log_action "Unsetting ${#_DZ_UNSET_VS[@]} internal variables ..." 1
_log_action "Unsetting ${#_DZ_UNSET_FS[@]} internal functions ..." 1
_log_normal 1 "--> Completed all operations ..."

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
