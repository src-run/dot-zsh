#!/usr/bin/env zsh

#
# This file is part of the `sr`-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#


#
# Get seconds since this script started.
#

function _get_unix_time_diff {
    local time_start="${1}"
    local time_ended="${2}"

    printf '%.5f' $((${time_ended} - ${time_start}))
}


#
# create ANSI color sequence with optional style
#
function _ansi_color {
    local color="${1}"
    local style="${2:-}"

    if [[ -z "${style}" ]]; then
        echo "\\e[${color}m"
    else
        echo -n "\\e[${color};${style}m"
    fi
}


#
# disable (clear) all console formatting attributes
#
function _ansi_clear {
    echo -n "\e[0m"
}


#
# enable styling attributes: bold, dim, underline, blink, invert, and hide
#
function _style_bold {
    echo -n "\e[1m"
}

function _style_dim {
    echo -n "\e[2m"
}

function _style_underline {
    echo -n "\e[4m"
}

function _style_blink {
    echo -n "\e[5m"
}

function _style_invert {
    echo -n "\e[7m"
}

function _style_hide {
    echo -n "\e[8m"
}

function _style_strikeout {
    echo -n "\e[9m"
}


#
# output foreground ANSI color sequence
#
function _fg_default {
    echo -n $(_ansi_color 39 "${1}")
}

function _fg_black {
    echo -n $(_ansi_color 30 "${1}")
}

function _fg_red {
    echo -n $(_ansi_color 31 "${1}")
}

function _fg_green {
    echo -n $(_ansi_color 32 "${1}")
}

function _fg_yellow {
    echo -n $(_ansi_color 33 "${1}")
}

function _fg_blue {
    echo -n $(_ansi_color 34 "${1}")
}

function _fg_magenta {
    echo -n $(_ansi_color 35 "${1}")
}

function _fg_cyan {
    echo -n $(_ansi_color 36 "${1}")
}

function _fg_light_gray {
    echo -n $(_ansi_color 37 "${1}")
}

function _fg_dark_gray {
    echo -n $(_ansi_color 90 "${1}")
}

function _fg_light_red {
    echo -n $(_ansi_color 91 "${1}")
}

function _fg_light_green {
    echo -n $(_ansi_color 92 "${1}")
}

function _fg_light_yellow {
    echo -n $(_ansi_color 93 "${1}")
}

function _fg_light_blue {
    echo -n $(_ansi_color 94 "${1}")
}

function _fg_light_magenta {
    echo -n $(_ansi_color 95 "${1}")
}

function _fg_light_cyan {
    echo -n $(_ansi_color 96 "${1}")
}

function _fg_white {
    echo -n $(_ansi_color 97 "${1}")
}


#
# output background ANSI color sequence
#
function _bg_default {
    echo -n $(_ansi_color 49 "${1}")
}

function _bg_black {
    echo -n $(_ansi_color 40 "${1}")
}

function _bg_red {
    echo -n $(_ansi_color 41 "${1}")
}

function _bg_green {
    echo -n $(_ansi_color 42 "${1}")
}

function _bg_yellow {
    echo -n $(_ansi_color 43 "${1}")
}

function _bg_blue {
    echo -n $(_ansi_color 44 "${1}")
}

function _bg_magenta {
    echo -n $(_ansi_color 45 "${1}")
}

function _bg_cyan {
    echo -n $(_ansi_color 46 "${1}")
}

function _bg_light_gray {
    echo -n $(_ansi_color 47 "${1}")
}

function _bg_dark_gray {
    echo -n $(_ansi_color 100 "${1}")
}

function _bg_light_red {
    echo -n $(_ansi_color 101 "${1}")
}

function _bg_light_green {
    echo -n $(_ansi_color 102 "${1}")
}

function _bg_light_yellow {
    echo -n $(_ansi_color 103 "${1}")
}

function _bg_light_blue {
    echo -n $(_ansi_color 104 "${1}")
}

function _bg_light_magenta {
    echo -n $(_ansi_color 105 "${1}")
}

function _bg_light_cyan {
    echo -n $(_ansi_color 106 "${1}")
}

function _bg_white {
    echo -n $(_ansi_color 107 "${1}")
}


#
# remove all ANSI SGR and EL escape sequences
#
function _ansi_rm_sgr_el {
    echo "${1}" | sed -r "s/\x1b\[([0-9]{1,2}(;[0-9]{1,2})*)?m//g"
}


#
# trim line width to max columns of terminal window
#
function _trim_line_width {
    local cols
    local line="${1}"

    cols=$(tput cols)

    if [[ ${#line} -gt ${cols} ]]; then
        cols=$((${cols} - 3))
        echo "${line:0:$cols}..."
    else
        echo "${line}"
    fi
}


#
# Define simple file logger function.
#

function _wrt_log {
    local d="${1}" ; shift
    local l="${1}" ; shift
    local c="${1}" ; shift
    local m="${1}" ; shift
    local p

    if [[ -z ${_DZ_LOG_BUFFER_LINES} ]]; then
        typeset -g _DZ_LOG_BUFFER_LINES
    fi

    p="$(printf '%s:%s' ${c} ${d})"
    _DZ_LOG_BUFFER_LINES+=("${p} $(printf ${m} "$@")")

    if [[ ! -z ${_DZ_LOGS_PATH} ]] && [[ "${#_DZ_LOG_BUFFER_LINES}" -gt 0 ]]; then
        for b in "${_DZ_LOG_BUFFER_LINES[@]}"; do
            echo "${b}" | \
                tee -a "${_DZ_LOGS_PATH}" &> /dev/null
        done

        _DZ_LOG_BUFFER_LINES=()
    fi

    _log_buffer_flush
}


#
# Define simple buffer flush function.
#

function _log_buffer_flush {
    if [[ ${_DZ_VERBOSITY} -lt 0 ]]; then
        return
    fi

    for line in ${_DZ_OUT_BUFFER_LINES[@]}; do
        _trim_line_width "$(printf '%s\n' "${line}")"
    done

    _DZ_OUT_BUFFER_LINES=()
}


#
# Define simple top-level std out logger function.
#

function _log_normal {
    local d
    local m
    local c="$USER/dot-zsh"
    local l="${1}" ; shift

    if [[ -z ${_DZ_STDIO_BUFF_NORMAL} ]]; then
        typeset -g _DZ_STDIO_BUFF_NORMAL
    fi

    d=$(_get_date %s)
    m="$(echo ${1} | sed 's/[ ]*$//g')" ; shift

    if [[ ! "${m}" ]]; then
        return
    fi

    _wrt_log "${d}" "${l}" "${c}" "${m}" "$@"
    _log_buffer 0 "$(printf ${m} "$@")"
}


#
# Define simple log notice.
#

function _log_warn_old {
    local d
    local c="$USER/dot-zsh"
    local m="!!! WARNING: $(echo ${1} | sed 's/[ ]*$//g')" ; shift
    local l="${1:-2}"

    d=$(_get_date %s)

    _wrt_log "${d}" "${l}" "${c}" "$(_out_indent ${l})${m}" "$@"
    _log_buffer 0 "$(printf ${m} "$@")"
}


#
# Define simple log warning.
#

function _log_warn {
    typeset -g _DZ_STDIO_BUFF_WARN


    local c="!!WARNING!!"
    local l=2
    local m="$1"
    local d
    local w

    shift

    d=$(_get_date %s)
    w="$(printf ${m} "$@")"

    _wrt_log "${d}" "${l}" "${c}" "$(_out_indent ${l})--> ${m}"
    _log_buffer 0 "$(printf "---> ${m}" "$@")"
}


#
# Define simple log notice.
#

function _log_crit {
    local d
    local c="$USER/dot-zsh"
    local m="!!! CRITICAL: $(echo ${1} | sed 's/[ ]*$//g')" ; shift
    local l="${1:-2}"

    d=$(_get_date %s)

    _wrt_log "${d}" "${l}" "${c}" "$(_out_indent ${l})${m}" "$@"
    _log_buffer 0 "$(printf ${m} "$@")"
}


#
# Define self repo name (from dir path) resolver function.
#

function _self_repo_parse_path {
    echo "$(basename "$(cd ${_DZ_PATH} && git rev-parse --show-toplevel)")"
}


#
# Define self repo name (from git remote) resolver function.
#

function _self_repo_parse_remote {
    echo "$(cd ${_DZ_PATH} && git remote get-url origin | sed 's/https\?:\/\///')"
}


#
# Checks if git has pending changes (is dirty tree)
#

function _self_repo_parse_is_dirty {
    git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && \
        echo "*"
}


#
# Gets the current git branch
#

function _self_repo_parse_branch {
    export _DZ_SELF_GIT_BRANCH
    local desc_dirty
    local show_dirty="${1:-0}"
    local postfix=""

    desc_dirty="$(_self_repo_parse_is_dirty)"

    if [[ "${show_dirty}" == "1" ]]; then
        postfix="${desc_dirty}"
        unset _DZ_SELF_GIT_BRANCH
    fi

    if [[ "${show_dirty}" == "0" ]] && [[ "$(echo "${_DZ_SELF_GIT_BRANCH}" | awk '{print substr($0,length,1)}')" == "*" ]]; then
        unset _DZ_SELF_GIT_BRANCH
    fi

    if [[ ${_DZ_SELF_GIT_BRANCH:-x} == "x" ]]; then
        _DZ_SELF_GIT_BRANCH="$(cd ${_DZ_PATH} && git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1${postfix}/" 2> /dev/null)"
    fi

    echo "${_DZ_SELF_GIT_BRANCH}"
}


#
# Get last commit hash prepended with @ (i.e. @8a323d0)
#
function _self_repo_parse_hash {
    export _DZ_SELF_COMMIT
    local prepend="${1:-0}"
    local prefix=""

    if [[ "${prepend}" == "1" ]]; then
        prefix="@"
        unset _DZ_SELF_COMMIT
    fi

    if [[ "${prepend}" == "0" ]] && [[ "${_DZ_SELF_COMMIT:0:1}" == "@" ]]; then
        unset _DZ_SELF_COMMIT
    fi

    if [[ ${_DZ_SELF_COMMIT:-x} == "x" ]]; then
        _DZ_SELF_COMMIT="$(cd ${_DZ_PATH} && git rev-parse HEAD 2> /dev/null | sed "s/\(.*\)/${prefix}\1/" 2> /dev/null)"
    fi

    echo "${_DZ_SELF_COMMIT}"
}


#
# Get the tag name if we're on one
#

function _self_repo_parse_tag {
    local always="${1:-0}"
    export _DZ_SELF_TAG

    if [[ ${_DZ_SELF_TAG:-x} == "x" ]]; then
        _DZ_SELF_TAG="$(cd ${_DZ_PATH} && git describe --exact-match ${s} HEAD 2> /dev/null)"
    fi

    if [[ ${_DZ_SELF_TAG:-x} == "x" ]] && [[ "${always}" ]]; then
        _DZ_SELF_TAG="$(cd ${_DZ_PATH} && git describe --all ${s} HEAD 2> /dev/null)"
    fi

    echo "${_DZ_SELF_TAG}"
}


#
# Define self repo name resolver function.
#

function _self_repo_repo {
    export _DZ_SELF_REPO
    local -a strategies=("_self_repo_parse_remote" "_self_repo_parse_path")

    if [[ ${_DZ_SELF_REPO:-x} == "x" ]]; then
        for s in "${strategies[@]}"; do
            _DZ_SELF_REPO="$(eval "${s}")" && [[ ${#_DZ_SELF_REPO} -gt 1 ]] && break
        done
    fi

    echo "${_DZ_SELF_REPO}"
}


#
# Define self author resolver function.
#

function _self_repo_whos {
    export _DZ_SELF_WHOS

    if [[ ${_DZ_SELF_WHOS:-x} == "x" ]]; then
        _DZ_SELF_WHOS="$(cd ${_DZ_PATH} && git shortlog -ne | head -n1 | grep -o -P '^[^\(]+' | sed 's/ *$//')"
    fi

    echo "${_DZ_SELF_WHOS}"
}


#
# Define self version resolver function.
#

function _self_repo_tag {
    export _DZ_SELF_TAG
    local -a strategies=("--exact-match" "--always")

    if [[ ${_DZ_SELF_TAG:-x} == "x" ]]; then
        _DZ_SELF_TAG="$(_self_repo_parse_tag)"
    fi

    echo "${_DZ_SELF_TAG}"
}


#
# Define self version resolver function.
#

function _self_repo_vers {
    export _DZ_SELF_VERS
    local -a strategies=("--exact-match" "--always")

    if [[ ${_DZ_SELF_VERS:-x} == "x" ]]; then
        for s in "${strategies[@]}"; do
            _DZ_SELF_VERS="$(cd ${_DZ_PATH} && git describe --tag ${s} HEAD 2> /dev/null)" && [[ ${#_DZ_SELF_VERS} -gt 4 ]] && break
        done

        if [[ "$(_self_repo_parse_is_dirty)" == "*" ]]; then
            _DZ_SELF_VERS="${_DZ_SELF_VERS} (dirty)"
        fi
    fi

    echo "${_DZ_SELF_VERS}"
}


#
# Define self commit resolver function.
#

function _self_repo_hash {
    export _DZ_SELF_HASH
    local -a strategies=("--exact-match" "--always")

    if [[ ${_DZ_SELF_HASH:-x} == "x" ]]; then
        _DZ_SELF_HASH="$(_self_repo_parse_hash)"
    fi

    echo "${_DZ_SELF_HASH}"
}


#
# Define zsh name resolver function.
#

function _self_repo_load {
    echo "${_DZ_NAME}"
}


#
# Define shell path resolver function.
#

function _parse_shell_path {
    echo "${SHELL}"
}


#
# Define zsh path resolver function.
#

function _parse_zsh_path {
    _DZ_ZSH_PATH="$(which zsh 2> /dev/null)"

    if [[ ${#_DZ_ZSH_PATH} -lt 3 ]]; then
        _log_warn "Failed to determine installed ZSH binary path!"
    fi

    echo "${_DZ_ZSH_PATH}"
}


#
# Define zsh version resolver function.
#

function _parse_zsh_version {
    _DZ_ZSH_VERSION="$(apt-cache show zsh 2> /dev/null | grep -E -o '^Version: .+' 2> /dev/null | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+(-.+)?' 2> /dev/null)"

    if [[ ${#_DZ_ZSH_VERSION} -lt 5 ]]; then
        local zsh_path="$(_parse_shell_path)"

        if [[ ${#zsh_path} -gt 2 ]]; then
            _DZ_ZSH_VERSION="$(${zsh_path} --version | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+(\s\([^)]+\))?' 2> /dev/null)"
        fi
    fi

    if [[ ${#_DZ_ZSH_VERSION} -lt 5 ]]; then
        _log_warn "Failed to determine installed ZSH binary version!"
    fi

    echo "${_DZ_ZSH_VERSION}"
}


#
# Get precise (microsecond-almost) time for profiler
#

function _profiler_get_precise_time {
    echo $(_get_date %s%N | cut -b1-13)
}


#
# Clear profiler times
#

function _profiler_clear {
    typeset -Ag _PROF
    typeset -Ag _PROF_S
    typeset -Ag _PROF_E
    local name="${1:-main}"

    if [[ ${_PROF[$name]} ]]; then
        unset _PROF[$name]
    fi

    if [[ ${_PROF_S[$name]} ]]; then
        unset _PROF_S[$name]
    fi

    if [[ ${_PROF_E[$name]} ]]; then
        unset _PROF_E[$name]
    fi
}


#
# Begin profiler timer
#

function _profiler_begin {
    typeset -Ag _PROF
    typeset -Ag _PROF_S
    typeset -Ag _PROF_E
    local name="${1:-main}"

    if [[ ${_PROF[$name]} ]]; then
        unset _PROF[$name]
    fi

    if [[ ${_PROF_E[$name]} ]]; then
        unset _PROF_E[$name]
    fi

    _PROF_S[$name]=$(_profiler_get_precise_time)
}


#
# Close (end) profiler timer
#

function _profiler_close {
    typeset -Ag _PROF_S
    typeset -Ag _PROF_E
    local name="${1:-main}"

    if [[ ! ${_PROF_S[$name]} ]]; then
        _profiler_clear ${name}
        return
    fi

    _PROF_E[$name]=$(_profiler_get_precise_time)
}


#
# Get profiler begin/close time difference
#

function _profiler_diff {
    typeset -Ag _PROF_S
    typeset -Ag _PROF_E
    typeset -Ag _PROF_D
    local name="${1:-main}"
    local s
    local e

    if [[ ${_PROF[$name]} ]]; then
        echo ${_PROF[$name]}
        return
    fi

    if [[ ! ${_PROF_S[$name]} ]] || [[ ! ${_PROF_E[$name]} ]]; then
        _profiler_clear ${name}
        return
    fi

    s=${_PROF_S[$name]}
    e=${_PROF_E[$name]}

    ${_PROF_D[$name]}=$(bc <<< "scale=4; ( ${e} - ${s} ) / 1000")

    echo ${_PROF_D[$name]}
}


#
# Implode newline to single line with "\n" strings
#

function _flatten_lines {
    echo "${@}" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/<nl>/g'
}


#
# Define fancy complete message display function.
#

function _wrt_completion_summary {
    local frmt_stat="%s - %s - %s"
    local frmt_desc="%sInitialized %s%s@%s%s shell configuration%s"
    local frmt_time="%s(%sloaded in %s seconds%s)%s"
    local text_stat="${1:-OK}"
    local text_desc
    local text_time
    local text_comp
    local text_comp_no_seq
    local columns
    local pre_pad=0

    columns=$(tput cols)

    text_desc="$(
        printf "${frmt_desc}" \
            "$(_ansi_clear; _fg_light_gray; _style_dim)" \
            "$(_style_bold)" \
            "${USER}" \
            "$(hostname -s)" \
            "$(_ansi_clear; _fg_light_gray; _style_dim)" \
            "$(_ansi_clear)"
    )"

    text_time="$(
        printf "${frmt_time}" \
            "$(_fg_dark_gray; _style_dim)" \
            "$(_fg_dark_gray)" \
            "$(
                _get_unix_time_diff \
                    "${_DZ_LOAD_TIME_START}" \
                    "$(_get_microtime)"
            )" \
            "$(_fg_dark_gray; _style_dim)" \
            "$(_ansi_clear)"
    )"

    text_stat="$(
        printf "${frmt_stat}" \
            "$(_fg_green; _bg_black; _style_invert; _style_bold)" \
            "${text_stat}" \
            "$(_ansi_clear)"
    )"

    text_comp="$(
        printf "%s %s $(_fg_light_gray; _style_dim)...$(_ansi_clear) %s" \
            "${text_desc}" \
            "${text_time}" \
            "${text_stat}"
    )"

    text_comp_no_seq=$(_ansi_rm_sgr_el "${text_comp}")
    pre_pad=$((${columns} - ${#text_comp_no_seq} - 1))

    _ansi_clear
    echo -en "\n"

    if [[ ${pre_pad} -gt 0 ]]; then
        for i in $(seq 1 ${pre_pad}); do
            echo -en ' '
        done
    fi

    echo -en "${text_comp}\n" && \
        _ansi_clear
}


#
# Define simple logger for include files.
#

function _log_source {
    local i="$1" ; shift ; local l="$1" ; shift ; local m="$1" ; shift

    _log_normal "${l}" "$(_out_indent ${i})--> ${m}" "$@"
}


#
# Define simple logger for include files.
#

function _log_action {
    local m="$(_flatten_lines "${1}")" ; shift ; local i="${1:-2}"

    if [[ "${1}" != "" ]]; then
        shift
    fi

    _log_normal 4 "$(_out_indent ${i})--- ${m}" "$@"
}


#
# Add passed directory to environment PATH variable
#

function _add_env_path_dir {
    local p
    local t

    p=$(zsh -c "echo ${1}")
    t="${2:-default}"

    if [[ ! -d "${p}" ]]; then
        _log_normal 2 \
            "        --- Skipping '${p}' addition to 'PATH' environment variable (does not exist)"
        return
    fi

    if [[ ":$PATH:" == *":${p}:"* ]]; then
        _log_normal 2 \
            "        --- Skipping '${p}' addition to 'PATH' environment variable (already added)"
        return
    fi

    PATH="${p}:${PATH}" && \
        _log_source 2 2 \
            "Registering '${p}' in 'PATH' environment variable (${t})"
}


#
# Setup and assign the ssh aliases via the configured variables
#

function _aliases_setup_ssh_connections {
    local prefixes=( "ssh-" "s-" "" )
    local opts_desc
    local host
    local port
    local user
    local opts
    local wait
    local alias_k
    local alias_v

    for name in $(_config_read_index_key 'define.aliases.ssh_connections'); do
        host="$(
            _config_read_string \
                "define.aliases.ssh_connections[\"${name}\"].host" \
                'false'
        )"

        if [[ "${host}" == 'false' ]]; then
            continue;
        fi

        port="$(
            _config_read_integer \
                "define.aliases.ssh_connections[\"${name}\"].port" \
                'false'
        )"

        if [[ "${port}" == 'false' ]]; then
            port=22
        fi

        user="$(
            _config_read_string \
                "define.aliases.ssh_connections[\"${name}\"].user" \
                'false'
        )"

        if [[ "${user}" == 'false' ]]; then
            user="${USER}"
        fi

        opts="$(
            _config_read_string \
                "define.aliases.ssh_connections[\"${name}\"].opts" \
                'false'
        )"

        if [[ "${opts}" == 'false' ]]; then
            opts="-y -v"
        fi

        wait="$(
            _config_read_integer \
                "define.aliases.ssh_connections[\"${name}\"].wait" \
                'false'
        )"

        if [[ "${wait}" == 'false' ]]; then
            wait=1.0
        fi

        opts_desc="${opts}"
        [[ -z "${opts_desc}" ]] && opts_desc="null"

        for prefix in "${prefixes[@]}"; do
            alias_key="${prefix}${name}"
            alias_val="$(
                _aliases_build_ssh_command \
                    "${name}" \
                    "${user}" \
                    "${host}" \
                    "${port}" \
                    "${opts}" \
                    "${wait}"
            )"

            if ( which "${alias_key}" &> /dev/null ); then
                continue && \
                    _log_action "Alias skipped (name exists) "\
                        "'${alias_key}=\"${alias_val}\"'"
            fi

            alias $alias_key="${alias_val}" &> /dev/null && \
                _log_action "Alias defined '${alias_key}' => '${alias_val}'"
        done
    done
}


#
# Build SSH connection alias command
#

function _aliases_build_ssh_command {
    local name="${1}"
    local user="${2}"
    local host="${3}"
    local port="${4}"
    local opts="${5}"
    local wait="${6}"
    local output
    local format

    format=${format}'\\n'
    format=${format}'  #\\n'
    format=${format}'  # INITIALIZING ALIASED SSH CONNECTION\\n'
    format=${format}'  #\\n'
    format=${format}'  # \$name --> \"%s\"\\n'
    format=${format}'  # \$user --> \"%s\"\\n'
    format=${format}'  # \$host --> \"%s\"\\n'
    format=${format}'  # \$opts --> \"%s\"\\n'
    format=${format}'  #\\n'
    format=${format}'  # Connecting in %s seconds...\\n'
    format=${format}'  #\\n'
    format=${format}'\\n'

    output="$(
        printf "${format}" \
            "${name}" \
            "${user}" \
            "${host}" \
            "${opts}" \
            "${wait}"
    )"

    printf 'clear;'
    printf 'echo -en "%s";' "${output}"
    printf 'sleep %f;' "${wait}"
    printf 'ssh -l "%s" -p %d %s %s;' \
        "${user}" \
        "${port}" \
        "${opts}" \
        "${host}" | \
        awk '$1=$1'
}


#
# Read and cache config file
#

function _config_read_file {
    if [[ -z ${_DZ_INC_JSON_CONF_CONTENTS} ]]; then
        typeset -g _DZ_INC_JSON_CONF_CONTENTS
        _DZ_INC_JSON_CONF_CONTENTS="$(cat "${_DZ_INC_JSON_CONF}")"
    fi

    echo "${_DZ_INC_JSON_CONF_CONTENTS}"
}


#
# Read configuration string
#

function _config_read_index_key {
    local jq_bin
    local jq_key=".${1:-} | keys"
    local return

    if [[ ! -f "${_DZ_INC_JSON_CONF}" ]]; then
        return
    fi

    jq_bin="$(which jq)"

    if [[ $? -ne 0 ]]; then
        return
    fi

    _config_read_file | ${jq_bin} -e -r "${jq_key}" | grep -o -E '[a-Z_]+'

    return $?
}


#
# Read configuration string
#

function _config_read_index_val {
    local jq_bin
    local jq_key=".${1:-}"
    local return

    if [[ ! -f "${_DZ_INC_JSON_CONF}" ]]; then
        return
    fi

    jq_bin="$(which jq)"

    if [[ $? -ne 0 ]]; then
        return
    fi

    _config_read_file | ${jq_bin} -e -r "${jq_key}"

    return $?
}


#
# Read configuration string
#

function _config_read_index_type {
    local jq_bin
    local jq_key=".${1:-} | type"
    local return

    if [[ ! -f "${_DZ_INC_JSON_CONF}" ]]; then
        return
    fi

    jq_bin="$(which jq)"

    if [[ $? -ne 0 ]]; then
        return
    fi

    _config_read_file | ${jq_bin} -e -r "${jq_key}"

    return $?
}


#
# Read configuration string
#

function _config_read_string_required {
    if [[ "$(_config_read_index_type "${1}")" != "string" ]]; then
        _log_crit "Configuration index '${1}' is not a string!"
    fi

    _config_read_index_val "${1} | @text"
}


#
# Read configuration string
#

function _config_read_array_values_required {
    if [[ "$(_config_read_index_type "${1}")" != "array" ]]; then
        _log_crit "Configuration index '${1}' is not an array!"
    fi

    _config_read_index_val "${1}[] | @text"
}


#
# Replace inner paths from JSON string
#

function _config_resolve_string {
    local index="${1%.*}"; shift
    local value="${@}"
    local search
    local replace
    search=$(
        echo "${value}" | \
            grep -o -E '{{[^}]+}}' | \
            grep -o -E '[^{}]+'
    )

    if [[ "${search}" != "" ]]; then
        replace="$(_config_read_string_required "${index}.${search}" 2> /dev/null)"

        if [[ $? -eq 0 ]]; then
            eval echo -e "${value/\{\{$search\}\}/$replace}"

            return
        fi
    fi

    eval echo -e "${value}"
}


#
# Replace inner paths from JSON array
#

function _config_resolve_array {
    local index="${1}"; shift

    for value in ${@}; do
        _config_resolve_string "${index}" "${value}"
    done
}


#
# Read configuration string
#

function _config_read_string {
    local value

    if [[ "$(_config_read_index_type "${1}" 2> /dev/null)" != "string" ]]; then
        echo "${2}" && return 1
    fi

    value="$(_config_resolve_string "${1}" $(_config_read_index_val "${1} | @text" 2> /dev/null))"

    if [[ "${value}" == "" ]]; then
        echo "${2}" && return 1
    fi

    echo "${value}"

    return 0
}


#
# Read configuration string
#

function _config_read_integer {
    local value

    if [[ "$(_config_read_index_type "${1}" 2> /dev/null)" != "number" ]]; then
        echo "${2}" && return 1
    fi

    value="$(_config_read_index_val "${1} | @text" 2> /dev/null)"

    if [[ "${value}" == "" ]]; then
        echo "${2}" && return 1
    fi

    echo "${value}"

    return 0
}


#
# Read configuration boolean as string
#

function _config_read_boolean {
    local default="${2:-}"

    if [[ "${default}" != "true" ]]; then
        default="false"
    fi

    if [[ "$(_config_read_index_type "${1}" 2> /dev/null)" != "boolean" ]]; then
        echo "${default}" && return
    fi

    _config_read_index_val "${1} | @text" 2> /dev/null || echo "${default}"
}


#
# Read configuration boolean as return
#

function _config_return_boolean {
    if [[ "$(_config_read_boolean "${1}" "${2:-}")" == "true" ]]; then
        return 0
    else
        return 1
    fi
}


#
# Read configuration string
#

function _config_read_array_vals {
    local value

    if [[ "$(_config_read_index_type "${1}" 2> /dev/null)" != "array" ]] && [[ "$(_config_read_index_type "${1}" 2> /dev/null)" != "object" ]]; then
        echo "${2}" && return
    fi

    _config_resolve_array "${1}[]" $(_config_read_index_val "${1}[] | @text" 2> /dev/null | xargs || echo "${2}")
}


#
# Read configuration string
#

function _config_read_array_assoc {
    local value
    local keys

    if [[ "$(_config_read_index_type "${1}" 2> /dev/null)" != "object" ]]; then
        echo "${2}" && return
    fi

    for k in $(_config_read_index_key "${1}"); do
        echo -en "${k}="
        _config_resolve_string "${1}[\"${k}\"]" $(_config_read_index_val "${1}[\"${k}\"] | @text" 2> /dev/null || echo "${2}")
    done
}


#
# Get the index from a key=val string
#

function _get_array_key {
    echo "${1%%=*}"
}


#
# Get the value from a key=val string
#

function _get_array_val {
    echo "${1#*=}"
}


#
# Format log source file message
#

function _printf_log_src {
    local what="${1}"
    local file="${2}"
    local desc="${3:-}"
    local levl="${4:-1}"
    local type="${5:-}"
    local base
    local text

    base="$(
        basename "${file}" | cut -d. -f1
    )"

    if [[ -z "${type}" ]]; then
        type="$(
            echo "${base}" | \
                cut -d- -f3- | \
                cut -d- -f2
        )"
    fi

    text="$(
        printf "$(_out_indent "${levl}")==> %s %s file include '%s'" \
            "${what}" \
            "${type}" \
            "${file/$_DZ_PATH\//}"
    )"

    if [[ ! -z "${desc}" ]]; then
        text="$(
            printf '%s (%s)' \
                "${text}" \
                "${desc}"
        )"
    fi

    echo "${text}"
}


#
# Log file source failure
#

function _log_src_fail {
    local file="${1}"
    local desc="${2:-unknown reason}"
    local levl=${3:-1}
    local what=${4:-}

    _log_normal ${levl} "$(
        _printf_log_src 'Failures for' "${file}" "${desc}" ${levl} "${what}"
    )"
}


#
# Log file source skip
#

function _log_src_skip {
    local file="${1}"
    local desc="${2:-unknown reason}"
    local levl=${3:-1}
    local what=${4:-}

    _log_normal ${levl} "$(
        _printf_log_src 'Skipping the' "${file}" "${desc}" ${levl} "${what}"
    )"
}


#
# Log file source
#

function _log_src_done {
    local file="${1}"
    local desc="${2:-}"
    local levl=${3:-1}
    local what=${4:-}

    _log_normal ${levl} "$(
        _printf_log_src 'Sourcing the' "${file}" "${desc}" ${levl} "${what}"
    )"
}


#
# Check if extern include file exists and is enabled
#

function _check_extern_source_file {
    local file="${1}"
    local levl="${2:-1}"
    local what="${3:-}"
    local base
    local type

    if [[ ! -f "${file}" ]]; then
        _log_src_fail "${file}" 'does not exist' ${levl} "${what}"
        return 255
    fi

    if [[ ! -r "${file}" ]]; then
        _log_src_fail "${file}" 'is not readable' ${levl} "${what}"
        return 255
    fi

    base="$(
        basename "${file}" | cut -d. -f1
    )"

    _log_src_done "${file}" "$(
        printf '%s' "$(echo "${base}" | tr '-' ' ')"
    )" ${levl} "${what}"

    return 0
}


#
# Check if extern include file exists and is enabled
#

function _check_extern_source_file_enabled {
    local file="${1}"
    local levl="${2:-1}"
    local base
    local type
    local name

    if [[ ! -f "${file}" ]]; then
        _log_src_fail "${file}" 'does not exist' ${levl}
        return 255
    fi

    if [[ ! -r "${file}" ]]; then
        _log_src_fail "${file}" 'is not readable' ${levl}
        return 255
    fi

    base="$(basename "${file}" '.zsh')"

    type="$(
        echo "${base}" | \
            cut -d- -f3- | \
            cut -d- -f2
    )"

    name="$(
        echo "${base}" | \
            cut -d- -f5-
    )"

    if [[ "$(_config_read_boolean "${type}[\"${name}\"]._enabled")" != 'true' ]]; then
        _log_src_skip "${file}" 'disabled in configuration' ${levl}
        return 255
    fi

    _log_src_done "${file}" "$(
        printf '%s' "$(echo "${name}" | tr '-' ' ')"
    )" ${levl}

    return 0
}


#
# Set IFS to newline (saving previous state)
#

function _ifs_newlines {
    if [[ -z ${IFS_ORIGINAL} ]]; then
        typeset -g IFS_ORIGINAL
    fi

    IFS_ORIGINAL="${IFS}"
    IFS='
'
}


#
# Reset IFS to previous state
#

function _ifs_reset {
    if [[ ! -z ${IFS_ORIGINAL} ]]; then
        IFS="${IFS_ORIGINAL}"
    fi
}


function _add_2col_aligned_to_middle_row {
    local padding="${1}"
    local col_key="${2}"
    local col_val="${3}"
    local pre_str="${4:----}"

    [[ -z ${_BZ_OUT_BUFF_2CATMR_STRING} ]] && \
        typeset -g -A _BZ_OUT_BUFF_2CATMR_STRING
    [[ -z ${_BZ_OUT_BUFF_2CATMR_PREFIX} ]] && \
        typeset -g -A _BZ_OUT_BUFF_2CATMR_PREFIX
    [[ -z ${_BZ_OUT_BUFF_2CATMR_INDENT} ]] && \
        typeset -g -A _BZ_OUT_BUFF_2CATMR_INDENT

    _BZ_OUT_BUFF_2CATMR_PREFIX[$col_key]="${pre_str}"
    _BZ_OUT_BUFF_2CATMR_INDENT[$col_key]="${padding}"
    _BZ_OUT_BUFF_2CATMR_STRING[$col_key]="${col_val}"
}

function _resolve_value_type {
    local value="${1}"
    local temps=
    local rfile=0

    if [[ ${value} =~ '^[0-9]+$' ]]; then
        echo -en "number : integer" && return
    fi

    if [[ ${value} =~ '^[0-9]+\.[0-9]*$' ]]; then
        echo -en "number : float" && return
    fi

    if [[ ${value} =~ '^[0-9]+\.[0-9]+\.[0-9]+-[0-9]+?[a-z]+[0-9]+?' ]]; then
        echo -en "version : sys pkgs" && return
    fi

    if [[ ${value} =~ '^([0-9]+\.[0-9]+\.[0-9]+|[a-z]+)(-[0-9]+)?(-[a-z0-9]{7,8})(\s?\([a-z]+\))?$' ]]; then
        echo -en "version : git hash" && return
    fi

    if [[ "${value:0:1}" != "/" ]]; then
        setopt +o nomatch

        ls **/"${value}" &> /dev/null

        if [[ $? -eq 0 ]]; then
            value="$(ls **/"${value}" 2> /dev/null)"
            rfile=1
        fi

        setopt -o nomatch
    fi

    if [[ -L "${value}" ]]; then
        echo -en "link : " \
            && [[ ${rfile} -eq 1 ]] \
            && echo -en 'relative' \
            || echo -en 'absolute'
        return
    fi

    if [[ -d "${value}" ]]; then
        echo -en "path : " \
            && [[ ${rfile} -eq 1 ]] \
            && echo -en 'relative' \
            || echo -en 'absolute'
        return
    fi

    if [[ -e "${value}" ]]; then
        echo -en "file : " \
            && [[ ${rfile} -eq 1 ]] \
            && echo -en 'relative' \
            || echo -en 'absolute'
        return
    fi

    printf 'string : %02d chars' ${#value}
}

function _compile_2col_aligned_to_middle_row {
    local k_str="${1}"
    local k_max="${2}"
    local k_pad
    local v_str="${3}"
    local v_max="${4}"
    local v_pad
    local p_str

    k_pad=$(( ${k_max} - ${#k_str} + 5 ))
    v_pad=$(( ${v_max} - ${#v_str} ))

    for i in $(seq 1 ${k_pad}); do
        p_str="${p_str}."
    done

    printf "'%s' %s '%s'%-${v_pad}s  |  %18s\n" \
        "${k_str}" \
        "${p_str}" \
        "${v_str}" \
        "" \
        "$(_resolve_value_type "${v_str}")"
}

function _log_2col_aligned_to_middle_row {
    local k_len
    local v_len
    local final
    typeset -A lines

    for k v in ${(@kv)_BZ_OUT_BUFF_2CATMR_STRING}; do
        [[ ${#k} -gt ${k_len} ]] && k_len=${#k}
        [[ ${#v} -gt ${v_len} ]] && v_len=${#v}
    done

    for k v in ${(@kv)_BZ_OUT_BUFF_2CATMR_STRING}; do
        lines[$k]="$(
            _compile_2col_aligned_to_middle_row \
                "${k}" \
                "${k_len}" \
                "${v}" \
                "${v_len}"
        )"
    done
    _BZ_OUT_BUFF_2CATMR_STRING=()

    for k v in ${(@kv)lines}; do
        _log_normal \
            ${_BZ_OUT_BUFF_2CATMR_INDENT[$k]} \
            "$(_out_indent ${_BZ_OUT_BUFF_2CATMR_INDENT[$k]})${_BZ_OUT_BUFF_2CATMR_PREFIX[$k]} ${v}"
    done

    _BZ_OUT_BUFF_2CATMR_PREFIX=()
    _BZ_OUT_BUFF_2CATMR_INDENT=()
}
