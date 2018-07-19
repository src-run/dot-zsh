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
# Date function
#
function _get_date {
    local date

    date="$(which gdate)"

    if [[ $? -ne 0 ]]; then
        date="$(which date)"

        if [[ $? -ne 0 ]]; then
            return
        fi
    fi

    ${date} +"${1}"
}

#
# Define function to return microsecond aware unix time.
#
function _get_microtime {
    echo -n $(_get_date '%s.%N')
}


#
# String padding routine.
#

function _out_indent {
    for i in `seq 1 ${1:-2}`; do
        echo -n "    "
    done
}


#
# Format log output buffer
#
function _format_buffer {
    printf '[%s:%s] %s%s' \
        "${USER}/dot-zsh" \
        "$(_get_date %s)" \
        "$(_out_indent ${1})" \
        "$(echo "${2}" | sed 's/[ ]*$//g')"
}


#
# Add to output buffer
#
function _log_buffer {
    local indent="${1}"; shift
    local string

    if [[ -z ${_DZ_OUT_BUFFER_LINES} ]]; then
        typeset -g _DZ_OUT_BUFFER_LINES=()
    fi

    if [[ -z ${_DZ_LOG_BUFFER_LINES} ]]; then
        typeset -g _DZ_LOG_BUFFER_LINES=()
    fi

    for line in "${@}"; do
        string="$(_format_buffer ${indent} "${line}")"
        _DZ_OUT_BUFFER_LINES+=("${string}")
        _DZ_LOG_BUFFER_LINES+=("${string}")
    done
}


#
# Inform about script initialization
#
_log_buffer 0 "--> Initializing loader script ..."


#
# Get the start time so we can profile performnce start to end.
#

_DZ_LOAD_TIME_START=$(_get_microtime)
_log_buffer 1 "--- Starting micro-time is '${_DZ_LOAD_TIME_START}'"


#
# Define vars for script name, script dir path, and complete script file path.
#

_DZ_NAME="${(%):-%x}"
_DZ_BASE="$(basename ${_DZ_NAME})"
_DZ_PATH="${HOME}/.dot-zsh"
_DZ_CFG_ENABL_PATH="${_DZ_PATH}/confs-enabled"
_DZ_INC_ENABL_PATH="${_DZ_PATH}/incs-enabled"
_DZ_REQ_INC_FILES=("${_DZ_PATH}/incs-common/env-define-variables-intern.zsh")
_DZ_REQ_INC_FILES+=("${_DZ_PATH}/incs-common/env-define-functions-intern.zsh")
_DZ_INC_VARIABLES="${_DZ_PATH}/incs-common/env-define-variables-intern.zsh"
_DZ_INC_FUNCTIONS="${_DZ_PATH}/incs-common/env-define-functions-intern.zsh"
_DZ_INC_JSON_CONF="${HOME}/.dot-zsh.json"
_DZ_VERBOSITY=-5
_DZ_STIO_BUFF=-1


#
# Source requires variables assignments and function definitions
#
for f in "${_DZ_REQ_INC_FILES[@]}"; do
    if [[ ! -r "${f}" ]]; then
        printf \
            "Required file include is not readable or does not exist: %s" \
            "${f}" && \
            exit 255
    fi

    source "${f}" && \
        _log_buffer 1 "--- Sourcing core file '${f}'"
done


#
# Let the user know we've begun and provide some environment context
#

_add_2col_aligned_to_middle_row 1 "PROJECT NAME" \
    "${_DZ_BASE}"
_add_2col_aligned_to_middle_row 1 "PRIMARY AUTHOR" \
    "$(_self_repo_whos)"
_add_2col_aligned_to_middle_row 1 "RELEASE VERSION" \
    "$(_self_repo_vers)"
_add_2col_aligned_to_middle_row 1 "GIT REMOTE" \
    "$(_self_repo_repo)"
_add_2col_aligned_to_middle_row 1 "GIT REFERENCE" \
    "$(_self_repo_tag)"
_add_2col_aligned_to_middle_row 1 "GIT COMMIT" \
    "$(_self_repo_hash)"
_add_2col_aligned_to_middle_row 1 "CONFIGURATION FILE" \
    "${_DZ_INC_JSON_CONF}"
_add_2col_aligned_to_middle_row 1 "LOADER SCRIPT PATH" \
    "$(_self_repo_load)"
_add_2col_aligned_to_middle_row 1 "PREVIOUS SHELL BIN PATH" \
    "$(_parse_shell_path)"
_add_2col_aligned_to_middle_row 1 "FOUND ZSH BIN PATH" \
    "$(_parse_zsh_path)"
_add_2col_aligned_to_middle_row 1 "FOUND ZSH VERSION" \
    "$(_parse_zsh_version)"
_log_normal 3 '--> Loader script environment variables ...'
_log_2col_aligned_to_middle_row

#
#
#

_log_buffer_flush


#
# Load our configuration files.
#

_log_normal 1 \
    "--> Loading configuration file(s) from '${_DZ_CFG_ENABL_PATH}' ..."

for f in ${_DZ_CFG_ENABL_PATH}/??-???-*.zsh; do
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
    "--> Loading enabled include files(s) from '${_DZ_INC_ENABL_PATH}' ..."

for f in ${_DZ_INC_ENABL_PATH}/??-???-*.zsh; do
    [[ ! -f "${f}" ]] && \
        _log_normal 1 \
            "    --> Failed to source include file '$(basename ${f})'" && \
        continue

    _log_normal 1 "    --> Sourcing include file '$(basename ${f})'" && \
        source "${f}"
done


#
# Generate completion message (can't be done after unsetting vars/functions)
#

_DZ_DONE_MESSAGE="$(_wrt_completion_summary)"


#
# Cleanup variables, functions, etc
#

_log_normal 1 "--> Performing final cleanup pass ..."
_log_action "Unsetting global variables defined by this script ..." 1

for v in ${_DZ_UNSET_VS[@]}; do
    eval "unset ${v}" && _log_action "Variable unset '${v}'"
done

_log_action "Unsetting global functions defined by this script ..." 1

for f in ${_DZ_UNSET_FS[@]}; do
    _log_action "Function unset '${f}'"
done

for f in ${_DZ_UNSET_FS[@]}; do
    eval "unset -f ${f}"
done


#
# Write completion message if verbosity high enough
#

_try_read_conf_bool_ret 'internal.dot_zsh_settings.show_summary' && \
    echo -en "${_DZ_DONE_MESSAGE}"

unset _DZ_DONE_MESSAGE
