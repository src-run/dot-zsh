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
# output new line
#

function _o_nl {
    echo -en "\n"
}


#
# format and output text
#

function _o_text {
    local format="${1:-}"
    shift

    [[ -z ${format} ]] \
        && return

    [[ ${#} -eq 0 ]] \
        && printf "${format}" \
        || printf "${format}" "${@}"
}


#
# format and output text
#

function _o_line {
    local format="${1:-}"
    shift

    _o_text "${format}" "${@}"
    _o_nl
}


#
# format and output text, returning the passed exit code
#

function _o_exit {
    local return="${1}"
    shift

    _o_text "${@}"
    return ${return}
}


#
# Get seconds since this script started.
#

function _get_unix_time_diff {
    local time_start="${1}"
    local time_ended="${2}"

    _o_text '%.4f' $((${time_ended} - ${time_start}))
}

#
# get the width of terminal (number of columns)
#

function _terminal_info_cols {
    _o_text '%s' "$(tput cols 2> /dev/null)"
}

#
# alias for _terminal_info_cols
#

function _terminal_dims_w {
    _terminal_info_cols
}

#
# get the height of terminal (number of rows/lines)
#

function _terminal_info_rows {
    _o_text '%s' "$(tput lines 2> /dev/null)"
}

#
# alias for _terminal_info_rows
#

function _terminal_dims_h {
    _terminal_info_rows
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

function _o_ansi_clear {
    echo -n "\e[0m"
}


#
# enable styling attributes: bold, dim, underline, blink, invert, and hide
#

function _o_style_bold {
    echo -n "\e[1m"
}

function _o_style_dim {
    echo -n "\e[2m"
}

function _o_style_underline {
    echo -n "\e[4m"
}

function _o_style_blink {
    echo -n "\e[5m"
}

function _o_style_invert {
    echo -n "\e[7m"
}

function _o_style_hide {
    echo -n "\e[8m"
}

function _o_style_strikeout {
    echo -n "\e[9m"
}


#
# output foreground ANSI color sequence
#

function _o_fg_default {
    echo -n $(_ansi_color 39 "${1}")
}

function _o_fg_black {
    echo -n $(_ansi_color 30 "${1}")
}

function _o_fg_red {
    echo -n $(_ansi_color 31 "${1}")
}

function _o_fg_green {
    echo -n $(_ansi_color 32 "${1}")
}

function _o_fg_yellow {
    echo -n $(_ansi_color 33 "${1}")
}

function _o_fg_blue {
    echo -n $(_ansi_color 34 "${1}")
}

function _o_fg_magenta {
    echo -n $(_ansi_color 35 "${1}")
}

function _o_fg_cyan {
    echo -n $(_ansi_color 36 "${1}")
}

function _o_fg_light_gray {
    echo -n $(_ansi_color 37 "${1}")
}

function _o_fg_dark_gray {
    echo -n $(_ansi_color 90 "${1}")
}

function _o_fg_light_red {
    echo -n $(_ansi_color 91 "${1}")
}

function _o_fg_light_green {
    echo -n $(_ansi_color 92 "${1}")
}

function _o_fg_light_yellow {
    echo -n $(_ansi_color 93 "${1}")
}

function _o_fg_light_blue {
    echo -n $(_ansi_color 94 "${1}")
}

function _o_fg_light_magenta {
    echo -n $(_ansi_color 95 "${1}")
}

function _o_fg_light_cyan {
    echo -n $(_ansi_color 96 "${1}")
}

function _o_fg_white {
    echo -n $(_ansi_color 97 "${1}")
}


#
# output background ANSI color sequence
#

function _o_bg_default {
    echo -n $(_ansi_color 49 "${1}")
}

function _o_bg_black {
    echo -n $(_ansi_color 40 "${1}")
}

function _o_bg_red {
    echo -n $(_ansi_color 41 "${1}")
}

function _o_bg_green {
    echo -n $(_ansi_color 42 "${1}")
}

function _o_bg_yellow {
    echo -n $(_ansi_color 43 "${1}")
}

function _o_bg_blue {
    echo -n $(_ansi_color 44 "${1}")
}

function _o_bg_magenta {
    echo -n $(_ansi_color 45 "${1}")
}

function _o_bg_cyan {
    echo -n $(_ansi_color 46 "${1}")
}

function _o_bg_light_gray {
    echo -n $(_ansi_color 47 "${1}")
}

function _o_bg_dark_gray {
    echo -n $(_ansi_color 100 "${1}")
}

function _o_bg_light_red {
    echo -n $(_ansi_color 101 "${1}")
}

function _o_bg_light_green {
    echo -n $(_ansi_color 102 "${1}")
}

function _o_bg_light_yellow {
    echo -n $(_ansi_color 103 "${1}")
}

function _o_bg_light_blue {
    echo -n $(_ansi_color 104 "${1}")
}

function _o_bg_light_magenta {
    echo -n $(_ansi_color 105 "${1}")
}

function _o_bg_light_cyan {
    echo -n $(_ansi_color 106 "${1}")
}

function _o_bg_white {
    echo -n $(_ansi_color 107 "${1}")
}


#
# remove all ANSI SGR and EL escape sequences
#

function _o_ansi_al_sequence_remove {
    _o_text '%s' "$(sed -r "s/\x1b\[([0-9]{1,2}(;[0-9]{1,2})*)?m//g" <<< "${1:-}")"
}


#
# calculate size of string
#

function _str_length {
    local text="${1}"
    local ansi="${2:-false}"

    if [[ ${ansi} == "false" ]]; then
        text="$(_o_ansi_al_sequence_remove "${text}")"
    fi

    printf "${text}" 2> /dev/null | wc --chars 2> /dev/null
}


#
# remove both leading and trailing whitespace
#

function _str_regexp_escape_chars {
    local text="${1}"

    _o_text '%s' "$(
        sed 's/[^^]/[&]/g; s/\^/\\^/g' 2> /dev/null <<< "${text}"
    )"
}


#
# trim edge of string from passed items
#

function _str_trim_edge {
    local text="${1:-}"
    local what="${2:- \\t\\n}"

    _o_text '%s' "$(
        sed -E '{ N; s/^['${what}']*//;s/['${what}']*$//g }' 2> /dev/null <<< "${text}"
    )"
}


#
# trim right of string from passed items
#

function _str_trim_right_chars {
    local text="${1:-}"
    local char="${2:- }"

    _o_text '%s' "$(sed 's/[${char}]*$//g' <<< "${text}")"
    return
    local text="${1:-}"
    local char="${2:- }"
    local regx='s/[%s]*$//g'

    _o_text '%s' "$(
        sed "$(
            _o_text "${regx}" "$(
                _str_regexp_escape_chars "${char[0]}"
            )"
        )" 2> /dev/null <<< "${text}"
    )"
}


#
# trim left of string from passed items
#

function _str_same_from_start {
    local string="${1}"
    local search="${2}"

    if [[ -n ${search} ]]; then
        if [[ ${string:0:${#search}} != ${search} ]]; then
            return 1
        fi
    fi
}


#
# to-do: figure out what this does
#

function _str_same_from_right {
    local string="${1}"
    local search="${2}"

    if [[ -n ${search} ]]; then
        if [[ ${string:$((${#string} - ${#search}))} != ${search} ]]; then
            return 1
        fi
    fi
}

function _str_tr_one_group {
    local opt="${1:--d}"
    local set="${2}"
    local val="${@:3}"

    _str_same_from_start "${set}" '[' \
        || set="[${set}"
    _str_same_from_right "${set}" ']' \
        || set+=']'
    _str_same_from_start "${set}" '[:' \
        || set="[:${set:1}"
    _str_same_from_right "${set}" ':]' \
        || set="${set:0:$((${#set} - 1))}:]"

    tr ${opt} "${set}" 2> /dev/null <<< "$(
        _o_text "${val}"
    )"
}

function _str_drop_space_chars {
    local text="${1}"

    sed 's/ //' 2> /dev/null <<< "$(
        _o_text "${1}"
    )"
}

function _str_only_graphed_chars {
    _str_tr_one_group '-cd' 'graph' "${@}"
}

function _str_only_printed_chars {
    _str_tr_one_group '-cd' 'print' "${@}"
}

function _str_drop_control_chars {
    _str_tr_one_group '-d' 'cntrl' "${@}"
}

function _str_find_matches_only {
    local search="${1}"
    local string="${2}"
    local option="${3:--P}"

    grep -o ${option} "${search}" 2> /dev/null <<< "${string}"
}


#
# Read and cache config file
#

function _cfg_get_json_contents {
    if [[ -z ${_DZ_INC_JSON_PATH_CONTENTS} ]]; then
        typeset -g _DZ_INC_JSON_PATH_CONTENTS
        _DZ_INC_JSON_PATH_CONTENTS="$(cat "${_DZ_INC_JSON_PATH}")"
    fi

    _o_text "%s" "${_DZ_INC_JSON_PATH_CONTENTS}"
}


#
# Map keys to callable ones.
#

function _cfg_nor_key {
    local key_org="${1:-}"
    local key_tmp
    local key_pos
    local key_b="${key_org}"

    key_org="$(sed -E 's/^[\.]{0,}(.+)$/\1/g' <<< "${1:-}")"
    key_tmp="$(sed -E 's/^\.?(([a-zA-Z0-9_]+\.)+)([a-zA-Z0-9-]+)$/\3/g' <<< "${key_org}")"
    key_pos=$((( ${#key_org} - ${#key_tmp} )))

    if [[ ${#key_tmp} -gt 0 ]] && [[ ${#key_org} -ne ${#key_tmp} ]] && [[ "${key_tmp}" == "${key_org:$key_pos}" ]]; then
        key_org="${key_org:0:$key_pos}$(sed 's/-/_/g' <<< "${key_tmp}")"
    fi

    _o_text ".${key_org}"
}


#
# Read configuration string
#

function _cfg_get_key {
    local jq_bin
    local jq_key=".${1:-}"

    if [[ ! -f "${_DZ_INC_JSON_PATH}" ]]; then
        return 255
    fi

    jq_bin="$(which jq)"

    if [[ $? -ne 0 ]]; then
        return 255
    fi

    _cfg_get_json_contents \
        | ${jq_bin} -e -r "$(_cfg_nor_key "${jq_key}") | keys" \
        | grep -o -E '[a-zA-Z0-9_-]+'

    return $?
}


#
# Read configuration string
#

function _cfg_get_val {
    local jq_bin
    local jq_key=".${1:-}"

    if [[ ! -f "${_DZ_INC_JSON_PATH}" ]]; then
        return 255
    fi

    jq_bin="$(which jq)"

    if [[ $? -ne 0 ]]; then
        return 255
    fi

    _cfg_get_json_contents \
        | ${jq_bin} -e -r "$(_cfg_nor_key "${jq_key}")"

    return $?
}


#
# Read configuration string
#

function _cfg_get_type {
    local jq_bin
    local jq_key=".${1:-}"
    local return

    if [[ ! -f "${_DZ_INC_JSON_PATH}" ]]; then
        return 255
    fi

    jq_bin="$(which jq)"

    if [[ $? -ne 0 ]]; then
        return 255
    fi

    _cfg_get_json_contents \
        | ${jq_bin} -e -r "$(_cfg_nor_key "${jq_key}") | type"

    return $?
}


#
# Read configuration string
#

function _cfg_req_string {
    if [[ "$(_cfg_get_type "${1}")" != "string" ]]; then
        _log_crit "Configuration index '${1}' is not a string!"
    fi

    _cfg_get_val "${1} | @text"
}


#
# Read configuration string
#

function _cfg_req_array_values {
    if [[ "$(_cfg_get_type "${1}")" != "array" ]]; then
        _log_crit "Configuration index '${1}' is not an array!"
    fi

    _cfg_get_val "${1}[] | @text"
}

function _cfg_val_sequence_interpret {
    local inputs="${@}"
    local result

    if ! result="$(eval "echo -ne "${inputs}"" 2> /dev/null)"; then
        if ! result="$(echo -ne "${inputs}" 2> /dev/null)"; then
            return 1
        fi
    fi

    if [[ -n "${result}" ]]; then
        _o_text "${result}"
    else
        _o_text "${inputs}"
    fi
}

function _cfg_resolve_anchor_replacement {
    local anchor_tag_init="${1}"
    local anchor_tag_term="${2}"
    local anchor_val_text="${3}"
    local anchor_ret_text
    local anchor_key_pref="${4}"
    local anchor_key_find="${anchor_val_text}"
    local value_provided="${@:4}"
    local value_answered

    if [[ -n ${anchor_key_pref} ]]; then
        anchor_key_find="${anchor_key_pref}.${anchor_val_text}"
    fi

    anchor_ret_text="$(
        _cfg_req_string "$(
            _cfg_nor_key "${anchor_key_find}"
        )" 2> /dev/null
    )"

    if [[ $? -ne 0 ]] || [[ -z ${anchor_ret_text} ]]; then
        return 1
    fi

    value_answered="$(
        _cfg_val_sequence_interpret \
            "${value_provided/\{\{$anchor_val_text\}\}/$anchor_ret_text}"
    )"

    [[ $? -ne 0 ]] && return 1 || return 0
}

function _cfg_val_intern_anchor_matches {
    local anchor_init="${1}"
    local anchor_term="${2}"
    local search_text="${3}"
    local anchor_regx
    local anchor_item

    anchor_init="$(
        _str_only_graphed_chars "${anchor_init}"
    )"
    anchor_term="$(
        _str_only_graphed_chars "${anchor_term}"
    )"
    anchor_regx="$(
        printf '%s((?!%s|%s).)+%s' \
            "$(_str_regexp_escape_chars "${anchor_init}")" \
            "${anchor_init}" \
            "${anchor_term}" \
            "$(_str_regexp_escape_chars "${anchor_term}")"
    )"

    _ifs_newlines

    for match in $(_str_find_matches_only "${anchor_regx}" "${search_text}" | _str_drop_space_chars); do
        [[ -z "${match}" ]] && continue

        if tmp="$(_cfg_resolve_anchor_replacement '{{' '}}' "${matched}" "${key}" "${val}")"; then
            val="${tmp}" && continue
        fi

        if tmp="$(_cfg_resolve_anchor_replacement '{{' '}}' "${matched}" '' "${val}")"; then
            val="${tmp}" && continue
        fi
    done

    _ifs_reset
}



#
# Replace inner paths from JSON string
#

function _cfg_val_intern_anchor_ref_resolver {
    local key="${1%.*}"; shift
    local val="${@}"
    local tmp
    local matched
    local product

    _ifs_newlines

    for matched in $(grep -o -E '\{\{[^{]+\}\}' <<< "${val}" | grep -o -E '[^{}]+'); do
        if [[ -z "${matched}" ]]; then
            continue
        fi

        if tmp="$(_cfg_resolve_anchor_replacement '{{' '}}' "${matched}" "${key}" "${val}")"; then
            val="${tmp}" && continue
        fi

        if tmp="$(_cfg_resolve_anchor_replacement '{{' '}}' "${matched}" '' "${val}")"; then
            val="${tmp}" && continue
        fi
    done

    _ifs_reset
    _o_text "${val}"
}


#
# Replace inner paths from JSON string
#

function _cfg_resolve_string {
    local key="${1%.*}"; shift
    local val="${@}"
    local matched
    local replace

    _ifs_newlines
    for matched in $(grep -o -E '\{\{[^{]+\}\}' <<< "${val}" | grep -o -E '[^{}]+');
    do
        if [[ -z "${matched}" ]]; then
            continue
        fi

        replace="$(_cfg_req_string "$(_cfg_nor_key "${key}.${matched}")" 2> /dev/null)"

        if [[ -n "${replace}" ]]; then
            val="$(eval "echo -e "${val/\{\{$matched\}\}/$replace}"" 2> /dev/null)" \
                && continue
        fi

        replace="$(_cfg_req_string "$(_cfg_nor_key "${matched}")" 2> /dev/null)"

        if [[ -n "${replace}" ]]; then
            val="$(eval "echo -e "${val/\{\{$matched\}\}/$replace}"" 2> /dev/null)" \
                && continue
        fi
    done
    _ifs_reset

    eval "echo -ne "${val}"" 2> /dev/null \
        || echo -ne "${val}"
}


#
# Replace inner paths from JSON array
#

function _cfg_resolve_array {
    local k="${1}"
    shift

    for val in ${@}; do
        _cfg_resolve_string "$(_cfg_nor_key "${k}")" "${val}"
        _o_nl
    done
}


#
# normalize the passed config value type to its full name
#

function _cfg_nor_type {
    local type="${1:-}"

    case "${type}" in
        s|str|string)
            _o_text 'string' \
                && return
            ;;
        n|num|number)
            _o_text 'number' \
                && return
            ;;
        b|bool|boolean)
            _o_text 'boolean' \
                && return
            ;;
        l|list)
            _o_text 'list' \
                && return
            ;;
        a|array)
            _o_text 'array' \
                && return
            ;;
        o|obj|object)
            _o_text 'object' \
                && return
            ;;
        e|empty|null)
            _o_text 'null' \
                && return
            ;;
        d|def|default)
            _o_text 'default' \
                && return
            ;;
        *)
            _o_text "${type}" \
                && return 1
    esac
}


#
# Checks if provided configuration index is of an expected type
#

function _cfg_is_type {
    local expected="${1:-}"
    local conf_key="${2:-}"
    local is_match=0
    local provided

    expected="$(
        _cfg_nor_type "${expected}"
    )"

    ( [[ $? -ne 0 ]] || [[ -z "${conf_key}" ]] ) \
        && return 1

    if [[ "${expected}" == list ]]; then
        _cfg_is_type array "${conf_key}" \
            && return 0

        _cfg_is_type object "${conf_key}" \
            && return 0
    fi

    provided="$(
        _cfg_get_type "$(
            _cfg_nor_key "${conf_key}"
        )" 2> /dev/null
    )"

    [[ "${provided}" == "${expected}" ]] \
        || return 1
}


#
# Checks if the provided configuration index is a null type
#

function _cfg_is_null {
    local conf_key="${1:-}"

    if ! _cfg_is_type null "${conf_key}" &> /dev/null; then
        return 1
    fi
}


#
# Checks if the provided configuration index is any empty type
#

function _cfg_is_bool_false_like {
    local conf_key="${1:-}"
    local exact_on="${1:-0}"
    local conf_ilk
    local conf_val

    conf_key="$(
        _cfg_nor_key "${conf_key}"
    )"

    conf_ilk="$(
        _cfg_nor_type "$(
            _cfg_get_type "${conf_key}"
        )"
    )"

    conf_val="$(
        _cfg_get_val "$(
            _cfg_nor_key "${conf_key}"
        )"
    )"

    [[ -z ${conf_val} ]] \
        && return

    case "${type_val}" in
        s|str|string)
            [[ ${conf_val} == '""' ]] \
                && return
            ;;
        n|num|number)
            [[ ${conf_val} -gt 0 ]] \
                && return
            ;;
        b|bool|boolean)
            _cast_bool_to_ret "${conf_val}" \
                && return
            ;;
        l|list)
            [[ ${conf_val} == "[]" ]] \
                && return
            [[ ${conf_val} == "{}" ]] \
                && return
            ;;
        a|array)
            [[ ${conf_val} == "[]" ]] \
                && return
            ;;
        o|obj|object)
            [[ ${conf_val} == "{}" ]] \
                && return
            ;;
        e|empty|null)
            _cfg_is_null "${conf_key}" \
                && return
            ;;
    esac

    return 1
}


#
# Attempt to resolve any value type
#

function _try_cfg_get_val {
    local try="${1}"
    local key="${2}"
    local def="${3:-}"
    local val
    local res

    key="$(_cfg_nor_key "${key}")"

    if ! _cfg_is_type "${try}" "${key}"; then
        _cfg_resolve_string "${key}" "${def}" \
            && return
    fi

    if [[ "${try}" == "object" ]] || [[ "${try}" == "array" ]]; then
        val="$(_cfg_get_val "${key}[] | @text" 2> /dev/null | xargs 2> /dev/null)"

        if [[ -z "${val}" ]]; then
            _cfg_resolve_array "${key}[]" ${def} && \
                return
        fi

        _cfg_resolve_array "${key}[]" ${val} \
            || _cfg_resolve_array "${key}[]" ${def}
    else
        val="$(_cfg_get_val "${key} | @text" 2> /dev/null)"

        if [[ -z "${val}" ]]; then
            _cfg_resolve_string "${key}" "${def}" && \
                return
        fi

        _cfg_resolve_string "${key}" "${val}" \
            || _cfg_resolve_string "${key}" "${def}"
    fi
}


#
# Read configuration string
#

function _cfg_get_string {
    _try_cfg_get_val string "${1}" "${2:-}"
}


#
# Read configuration string
#

function _cfg_get_number {
    _try_cfg_get_val number "${1}" "${2:-}"
}


#
# Read configuration boolean as string
#

function _cfg_get_bool {
    _try_cfg_get_val boolean "${1}" "${2:-false}"
}


#
# Read configuration boolean as return
#

function _cfg_ret_bool {
    if [[ "$(_cfg_get_bool "${1}" "${2}")" != "true" ]]; then
        return 1
    fi
}


#
# Read configuration array values
#

function _cfg_get_array_values {
    for v in $(_try_cfg_get_val $(_cfg_get_type "${1}") "${1}" "${2:-}"); do
        _o_text "${v} "
    done
}


#
# Read configuration array keys => values
#

function _cfg_get_array_assoc {
    local key="${1}"
    local set

    if _cfg_is_type object "${key}"; then
        for k in $(_cfg_get_key "${1}"); do
            _o_text '%s===>' "${k}" \
                && _try_cfg_get_val $(
                        _cfg_get_type "${key}[\"${k}\"]"
                    ) "${key}[\"${k}\"]" "${def}" \
                || _o_text "${def}"
            _o_nl
        done
    fi
}


#
# Read configuration array keys
#

function _cfg_get_array_keys {
    local key="${1}"
    local set

    if _cfg_is_type object "${key}" || _cfg_is_type array "${key}"; then
        for k in $(_cfg_get_key "${1}"); do
            _o_line '%s' "${k}"
        done
    fi
}


#
# Read configuration array size
#

function _cfg_get_array_size {
    local key="${1}"

    if ! _cfg_is_type object "${key}" && ! _cfg_is_type array "${key}"; then
        _o_text '%d' 0
    fi

    _o_text '%d' "$(_try_cfg_get_val number "${key} | length" 0)"
}


#
# trim line width to max columns of terminal window
#

function _trim_line_width {
    local cols
    local line="${1}"

    cols=$(_terminal_dims_w)

    if [[ ${#line} -gt ${cols} ]]; then
        cols=$((${cols} - 3))
        echo "${line:0:$cols}..."
    else
        echo "${line}"
    fi
}


#
# Return 0 if logging enabled, -255 otherwise.
#

function _logger_enabled {
    if [[ -z ${_DZ_LOG_ENABLED} ]]; then
        typeset -g _DZ_LOG_ENABLED
        _cfg_ret_bool 'systems.dot_zsh.logs.enabled'
        _DZ_LOG_ENABLED=$?
    fi

    return ${_DZ_LOG_ENABLED}
}


#
# Get log file path
#

function _logger_file_path {
    if [[ -z ${_DZ_INC_JSON_PATH} ]]; then
        typeset -g _DZ_INC_JSON_PATH
        _DZ_INC_JSON_PATH=$(
             _cfg_get_string \
            'systems.dot_zsh.logs.path' \
            "${HOME}/.dot-zsh.log"
        )
    fi
}


#
# Return 0 if logging enabled, -255 otherwise.
#

function _load_enabled {
    if [[ -z ${_DZ_LOAD_ENABLED} ]]; then
        typeset -g _DZ_LOAD_ENABLED
        _cfg_ret_bool 'systems.dot_zsh.show.loading'
        _DZ_LOAD_ENABLED=$?
    fi

    return ${_DZ_LOAD_ENABLED}
}


#
# Define simple file logger function.
#

function _wrt_log {
    _load_enabled \
        && _o_progress_write \
        || _o_progress_close

    local d="${1}" ; shift
    local l="${1}" ; shift
    local c="${1}" ; shift
    local m="${1}" ; shift
    local p

    if [[ -z ${_DZ_LOG_BUFFER_LINES} ]]; then
        typeset -g _DZ_LOG_BUFFER_LINES
    fi

    if [[ ${_DZ_IO_VERBOSITY} -lt 0 ]]; then
        return
    fi

    p="$(_o_text '%s:%s' ${c} ${d})"
    _DZ_LOG_BUFFER_LINES+=("${p} $(_o_text ${m} "$@")")

    if [[ ! -z ${_DZ_LOGS_PATH} ]] && [[ "${#_DZ_LOG_BUFFER_LINES}" -gt 0 ]]; then
        for b in "${_DZ_LOG_BUFFER_LINES[@]}"; do
            _logger_enabled && \
                echo "${b}" | tee -a "${_DZ_LOGS_PATH}" &> /dev/null
        done

        _DZ_LOG_BUFFER_LINES=()
    fi

    _file_out_buffer
    _buf_flush_lines
}


#
# Define simple buffer flush function.
#

function _buf_flush_lines {
    if [[ ${_DZ_IO_VERBOSITY} -lt 0 ]]; then
        return
    fi
    _o_progress_close

    for line in ${_DZ_IO_BUFF_LINES[@]}; do
        _trim_line_width "$(_o_text '%s\n' "${line}")"
    done

    _DZ_IO_BUFF_LINES=()
}


#
# Define simple top-level std out logger function.
#

function _log_norm {
    local d=$(_get_date %s)
    local c="${USER}/${_DZ_NAME}"
    local l="${1}"
    shift
    local m="$(_str_trim_right_chars "${1}")"
    shift

    if [[ -z ${_DZ_IO_BUFF_NORM} ]]; then
        typeset -g _DZ_IO_BUFF_NORM
    fi

    if [[ ! "${m}" ]]; then
        return
    fi

    _wrt_log "${d}" "${l}" "${c}" "${m}" "$@"
    _log_buffer 0 "$(_o_text ${m} "$@")"
}

function _get_log_control_action {
    local name="${1}"
    local default="${2}"

    for a in "${@:3}"; do
        if [[ ${a:0:$((${#name} + 1))} == "${name}:" ]] && [[ $((${#a} - $((${#name} + 1)))) -gt 0 ]]; then
            _o_text '%s' "${a:$((${#name} + 1))}"
            return 0
        fi
    done

    _o_text '%s' "${default}"
}

function _filter_control_actions {
    for s in "${@}"; do
        if [[ ${s} =~ ^[a-z]+:.+$ ]]; then
            continue
        fi

        printf '%s\n' "${s}"
    done
}

function _log_message_compile {
    local format="${1}"
    local interp=()
    local indent=$(_get_log_control_action indent 2 "${@:2}")
    local marker="$(_get_log_control_action marker '-->' "${@:2}")"
    local header="$(_get_log_control_action header '' "${@:2}")"
    local a_temp

    _ifs_newlines
    for a in $(_filter_control_actions "${@:2}"); do
        if ! [[ ${a} =~ ^[a-z]+:.*$ ]]; then
            interp+="${a}"
        fi
    done
    _ifs_reset

    if [[ ${#header} -gt 0 ]]; then
        header="$(tr '[:lower:]' '[:upper:]' <<< "${header}: ")"
    fi

    _o_text "%s%s %s${format}" "$(_out_indent ${indent})" "${marker}" "${header}" "${interp[@]}"
}

function _log_info {
    _wrt_log "$(_get_date %s)" 0 "${USER}/${_DZ_NAME}" "$(_log_message_compile "${@}")"
    _log_buffer 0 "$(_log_message_compile "${@}")"
}


#
# Define simple log warning.
#

function _log_warn {
    _wrt_log "$(_get_date %s)" 0 "${USER}/${_DZ_NAME}" "$(_log_message_compile "${@}" 'marker:###' 'header:warn')"
    _log_buffer 0 "$(_log_message_compile "${@}" 'marker:###' 'header:warn')"
}


#
# Define simple log notice.
#

function _log_crit {
    _wrt_log "$(_get_date %s)" 0 "${USER}/${_DZ_NAME}" "$(_log_message_compile "${@}" 'indent:0' 'marker:!!!' 'header:crit')"
    _log_buffer 0 "$(_log_message_compile "${@}" 'indent:0' 'marker:!!!' 'header:crit')"
}


#
# Simple info-level logger that interpolates the first format string argument
# with other passed replacement arguments, exposing the same signature as used
# with "_o_text" and other interpolating output functions.
#
# For example, take the following call, where the first argument defines the
# intended output string, and the remaining three arguments are all used as
# values for interpolation into the format string:
#
#  > _logf_info 'Encountered %d info errors with input value of %s: "%s"' \
#  >   ${errorCounter} \
#  >   ${usersInValue} \
#  >   ${errorMessage}
#

function _logf_info {
    _log_info "${@}"
}


#
# Simple warning-level logger that interpolates the first format string argument
# with other passed replacement arguments, exposing the same signature as used
# with "_o_text" and other interpolating output functions.
#
# For example, take the following call, where the first argument defines the
# intended output string, and the remaining three arguments are all used as
# values for interpolation into the format string:
#
#  > _logf_warn 'Encountered %d warning errors with input value of %s: "%s"' \
#  >   ${errorCounter} \
#  >   ${usersInValue} \
#  >   ${errorMessage}
#

function _logf_warn {
    _log_warn "${@}"
}


#
# Simple critical-level logger that interpolates the first format string argument
# with other passed replacement arguments, exposing the same signature as used
# with "_o_text" and other interpolating output functions.
#
# For example, take the following call, where the first argument defines the
# intended output string, and the remaining three arguments are all used as
# values for interpolation into the format string:
#
#  > _logf_crit 'Encountered %d critical errors with input value of %s: "%s"' \
#  >   ${errorCounter} \
#  >   ${usersInValue} \
#  >   ${errorMessage}
#

function _logf_crit {
    _log_crit "${@}"
}


#
# Simple info-level logger that handles interpolation of the format string
# just as "_logf_info" would (starting with the second argument and past), but
# adds a first argument to define the return value expected, allowing for
# "return" statements to be on the same line as the "_rlogf_info" call.
#
# For example, take the following call, where a info log entry is called and
# its return is then directly used to return from the shell context, as well:
#
#  > if is_func_return_true; do
#  >   return $(
#  >     _logrf_info 255 'Disabling selective feature: %s' "${featDescription}"
#  >   );
#  > fi
#

function _logrf_info {
    _logf_info "${@:2}"

    return $(
        _get_sanitized_return_code "${1}" 0
    )
}


#
# Simple warning-level logger that handles interpolation of the format string
# just as "_logf_warn" would (starting with the second argument and past), but
# adds a first argument to define the return value expected, allowing for
# "return" statements to be on the same line as the "_rlogf_warn" call.
#
# For example, take the following call, where a warning log entry is called and
# its return is then directly used to return from the shell context, as well:
#
#  > if is_failure; do
#  >   return $(
#  >     _logrf_warn 255 'We hit a snag: %s' "${errorDescription}"
#  >   );
#  > fi
#

function _logrf_warn {
    _logf_warn "${@:2}"

    return $(
        _get_sanitized_return_code "${1}" 0
    )
}


#
# Simple critical-level logger that handles interpolation of the format string
# just as "_logf_crit" would (starting with the second argument and past), but
# adds a first argument to define the return value expected, allowing for
# "return" statements to be on the same line as the "_rlogf_crit" call.
#
# For example, take the following call, where a critical log entry is called and
# its return is then directly used to return from the shell context, as well:
#
#  > if is_failure; do
#  >   return $(
#  >     _logrf_crit 255 'We hit a snag: %s' "${errorDescription}"
#  >   );
#  > fi
#

function _logrf_crit {
    _logf_crit "${@:2}"

    return $(
        _get_sanitized_return_code "${1}" 0
    )
}


#
# Sanitize a return status code, primarily by ensuring it is a number and not
# a string, boolean, or other type.
#

function _get_sanitized_return_code {
    local status="${1}"
    local useDef="${2:-0}"

    if ! [[ ${status} =~ ^-?[0-9]+$ ]]; then
        if [[ ${useDef} =~ ^-?[0-9]+$ ]]; then
            _logf_warn \
                'Passed return "%s" not an integer; using default: "%s".' \
                "${status}" "${useDef}"
            status=${useDef}
        else
            _logf_warn \
                'Passed return "%s" and passed default "%s" are not integers; '\
                'using hard-coded default: 0.' "${status}" "${useDef}"
            status=0
        fi
    fi

    _o_text "%d" "${status}"
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
    _DZ_ZSH_VERSION="$(apt-cache show zsh 2> /dev/null | grep -E -o '^Version: .+' 2> /dev/null | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+(-.+)?' 2> /dev/null | head -n1)"

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
# Define simple logger for include files.
#

function _log_source {
    local i="$1" ; shift ; local l="$1" ; shift ; local m="$1" ; shift

    _log_norm "${l}" "$(_out_indent ${i})--> ${m}" "$@"
}


#
# Define simple logger for include files.
#

function _log_action {
    local m="$(_flatten_lines "${1}")" ; shift ; local i="${1:-2}"

    if [[ "${1}" != "" ]]; then
        shift
    fi

    _log_norm 4 "$(_out_indent ${i})--- ${m}" "$@"
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
        _log_norm 2 \
            "        --- Skipping '${p}' addition to 'PATH' environment variable (does not exist)"
        return
    fi

    if [[ ":$PATH:" == *":${p}:"* ]]; then
        _log_norm 2 \
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
    local indented="${1:-3}"
    local prefixes=( "ssh-" "s-" "" )
    local opts_desc
    local host
    local port
    local user
    local opts
    local wait
    local alias_k
    local alias_v

    for name in $(_cfg_get_key 'configs.aliases.set_ssh_connections'); do
        host="$(
            _cfg_get_string \
                "configs.aliases.set_ssh_connections[\"${name}\"].host" \
                'false'
        )"

        if [[ "${host}" == 'false' ]]; then
            continue;
        fi

        port="$(
            _cfg_get_number \
                "configs.aliases.set_ssh_connections[\"${name}\"].port" \
                'false'
        )"

        if [[ "${port}" == 'false' ]]; then
            port=22
        fi

        user="$(
            _cfg_get_string \
                "configs.aliases.set_ssh_connections[\"${name}\"].user" \
                'false'
        )"

        if [[ "${user}" == 'false' ]]; then
            user="${USER}"
        fi

        opts="$(
            _cfg_get_string \
                "configs.aliases.set_ssh_connections[\"${name}\"].opts" \
                'false'
        )"

        if [[ "${opts}" == 'false' ]]; then
            opts="-y -v"
        fi

        wait="$(
            _cfg_get_number \
                "configs.aliases.set_ssh_connections[\"${name}\"].wait" \
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

            if _cfg_ret_bool 'configs.aliases.new_ssh_connections' 'true' && alias | grep -E "^${alias_key}=" &> /dev/null; then
                unalias "${alias_key}" 2> /dev/null \
                    && _log_action "Removed prior alias: '${alias_key}'" ${indented} \
                    || _log_action "Failed alias remove: '${alias_key}'" ${indented}
            fi

            alias "${alias_key}"="${alias_val}" &> /dev/null \
                && _log_action "Defined alias value: '${alias_key}' => '${alias_val}'" ${indented} \
                || _log_action "ailed alias assign: '${alias_key}' => '${alias_val}'" ${indented}
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
        _o_text "${format}" \
            "${name}" \
            "${user}" \
            "${host}" \
            "${opts}" \
            "${wait}"
    )"

    _o_text 'clear;'
    _o_text 'echo -en "%s";' "${output}"
    _o_text 'sleep %f;' "${wait}"
    _o_text 'ssh -l "%s" -p %d %s %s;' \
        "${user}" \
        "${port}" \
        "${opts}" \
        "${host}" | \
        awk '$1=$1'
}


#
# Get the index from a key=val string
#

function _get_array_key {
    echo "${1%%===>*}"
}


#
# Get the value from a key=val string
#

function _get_array_val {
    echo "${1#*===>}"
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
        _o_text "$(_out_indent "${levl}")==> %s %s file include '%s'" \
            "${what}" \
            "${type}" \
            "${file/$_DZ_PATH\//}"
    )"

    if [[ ! -z "${desc}" ]]; then
        text="$(
            _o_text '%s (%s)' \
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

    _log_norm ${levl} "$(
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

    _log_norm ${levl} "$(
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

    _log_norm ${levl} "$(
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
        _o_text '%s' "$(echo "${base}" | tr '-' ' ')"
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
    local nAlt

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

    if _cfg_ret_bool "${type}[\"${name}\"]._enabled"; then
        _log_src_done "${file}" "$(
            _o_text '%s' "$(echo "${name}" | tr '-' ' ')"
        )" ${levl}

        return 0
    fi

    nAlt="$(sed 's/-/_/g' <<< "${name}")"

    if _cfg_ret_bool "${type}[\"${nAlt}\"]._enabled"; then
        _log_src_done "${file}" "$(
            _o_text '%s' "$(echo "${name}" | tr '-' ' ')"
        )" ${levl}

        return 0
    fi

    _log_src_skip "${file}" 'disabled in configuration' ${levl}
    return 255
}


#
# Set IFS to newline (saving previous state)
#

function _ifs_newlines {
    if [[ -z ${_DZ_IFS_PRIOR} ]]; then
        typeset -g _DZ_IFS_PRIOR
    fi

    _DZ_IFS_PRIOR="${IFS}"
    IFS='
'
}


#
# Reset IFS to previous state
#

function _ifs_reset {
    if [[ ! -z ${_DZ_IFS_PRIOR} ]]; then
        IFS="${_DZ_IFS_PRIOR}"
    else
        IFS=" "
    fi
}


#
# resolve value type
#

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

    if [[ -L "${value}" ]]; then
        echo -en "link : " \
            && [[ "${value:0:1}" != "/" ]] \
            && echo -en 'relative' \
            || echo -en 'absolute'
        return
    fi

    if [[ -d "${value}" ]]; then
        echo -en "path : " \
            && [[ "${value:0:1}" != "/" ]] \
            && echo -en 'relative' \
            || echo -en 'absolute'
        return
    fi

    if [[ -e "${value}" ]]; then
        echo -en "file : " \
            && [[ "${value:0:1}" != "/" ]] \
            && echo -en 'relative' \
            || echo -en 'absolute'
        return
    fi

    _o_text 'string : %02d chars' ${#value}
}


#
# Buffer definition listing (with title and definition as arguments).
#

function _buf_definition_list {
    local padding="${1}"
    local col_key="${2}"
    local col_val="${3}"
    local pre_str="${4:----}"

    [[ -z ${_DZ_IO_BUFF_DEFINITION_VALUES} ]] && \
        typeset -g -A _DZ_IO_BUFF_DEFINITION_VALUES
    [[ -z ${_DZ_IO_BUFF_DEFINITION_PREFIX} ]] && \
        typeset -g -A _DZ_IO_BUFF_DEFINITION_PREFIX
    [[ -z ${_DZ_IO_BUFF_DEFINITION_INDENT} ]] && \
        typeset -g -A _DZ_IO_BUFF_DEFINITION_INDENT

    _DZ_IO_BUFF_DEFINITION_PREFIX[$col_key]="${pre_str}"
    _DZ_IO_BUFF_DEFINITION_INDENT[$col_key]="${padding}"
    _DZ_IO_BUFF_DEFINITION_VALUES[$col_key]="${col_val}"
}


#
# Create definition listing line for passed configuration.
#

function _get_definition_list_line {
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

    _o_text "'%s' %s '%s'%-${v_pad}s  |  %18s\n" \
        "${k_str}" \
        "${p_str}" \
        "${v_str}" \
        "" \
        "$(_resolve_value_type "${v_str}")"
}


#
# Log definition listing, aligning titles and definitions.
#

function _log_definition_list {
    local k_len
    local v_len
    local final
    typeset -A lines

    for k v in ${(@kv)_DZ_IO_BUFF_DEFINITION_VALUES}; do
        [[ ${#k} -gt ${k_len} ]] && k_len=${#k}
        [[ ${#v} -gt ${v_len} ]] && v_len=${#v}
    done

    for k v in ${(@kv)_DZ_IO_BUFF_DEFINITION_VALUES}; do
        lines[$k]="$(
            _get_definition_list_line \
                "${k}" \
                "${k_len}" \
                "${v}" \
                "${v_len}"
        )"
    done

    _DZ_IO_BUFF_DEFINITION_VALUES=()

    for k v in ${(@kv)lines}; do
        _log_norm \
            ${_DZ_IO_BUFF_DEFINITION_INDENT[$k]} \
            "$(_out_indent ${_DZ_IO_BUFF_DEFINITION_INDENT[$k]})${_DZ_IO_BUFF_DEFINITION_PREFIX[$k]} ${v}"
    done

    _DZ_IO_BUFF_DEFINITION_PREFIX=()
    _DZ_IO_BUFF_DEFINITION_INDENT=()
}


#
# reverse boolean value
#

function _cast_bool_to_inverse_string {
    local bool="${1:-1}"

    if _cast_bool_to_ret "${bool}"; then
        _o_text false
    else
        _o_text true
    fi
}


#
# reverse boolean value
#

function _cast_bool_to_string {
    local bool="${1:-1}"

    if _cast_bool_to_ret "${bool}"; then
        _o_text true
    else
        _o_text false
    fi
}


#
# reverse boolean value
#

function _cast_bool_to_ret {
    local bool="${1:-1}"

    if [[ $(_str_trim_edge ${bool}) =~ ^(true|TRUE|yes|YES|y|Y|0)$ ]]; then
        return 0
    else
        return 1
    fi
}


#
# reverse boolean value
#

function _cast_bool_to_int {
    local bool="${1:-1}"

    _cast_bool_to_ret "${1}"
    _o_text '%d' $?
}


#
# Add to output buffer
#

function _file_log_buffer {
    local string="${1}"
    local indent="${2:-3}"; shift

    _format_buffer ${indent} "${string}" >> "${_DZ_PATH_OUT_BUFFERING}"
    printf '\n' >> "${_DZ_PATH_OUT_BUFFERING}"
}


#
# Define simple buffer flush function.
#

function _file_out_buffer {
    if [[ ! -f "${_DZ_PATH_OUT_BUFFERING}" ]]; then
        return
    fi

    if [[ ${_DZ_IO_VERBOSITY} -lt 0 ]]; then
        rm -f "${_DZ_PATH_OUT_BUFFERING}"
    else
        _ifs_newlines
        for l in $(cat "${_DZ_PATH_OUT_BUFFERING}"); do
            _trim_line_width "$(_o_text '%s\n' "${l}")"
        done
        _ifs_reset

        if [[ -f "${_DZ_PATH_OUT_BUFFERING}" ]]; then
            rm -f "${_DZ_PATH_OUT_BUFFERING}"
        fi
    fi
}


#
# output variable assignment and return value back
#

function _log_assignment {
    local var="${1}"
    shift
    local val="${@}"

    if [[ "${val}" == "" ]]; then
        _file_log_buffer "--- Skipping '${var}' assignment (configured as empty value)"
    else
        _file_log_buffer "--- Assigned '${var}' to '${val}'"
    fi

    _o_text "${val}"
}




#
# Output padding of the specified length
#

function _o_padding {
    local padding_len="${1:-0}"
    local padding_str="${2:- }"

    if [[ ${padding_len} -gt 0 ]]; then
        for i in $(seq 1 ${padding_len}); do
            _o_text "${padding_str}"
        done
    fi
}


#
# Define fancy complete message display function.
#

function _load_summary_display {
    local padding_len=0
    local format_stat="%s - %s - %s"
    local format_info="%sInitialized %s%s@%s%s shell configuration%s"
    local format_used="%s(%sloaded in %s seconds and mapped %s%s memory%s)%s"
    local format_comp="%s %s %s...%s %s"
    local string_stat="${1:-OK}"
    local string_ansi
    local string_none
    local memory_used
    local memory_size
    local memory_type

    memory_used="$(
        pmap -d ${$} 2> /dev/null \
            | tail -n 1 2> /dev/null \
            | sed -E 's/^mapped: ([0-9]+[A-Z]{0,2}).+/\1/g' 2> /dev/null
    )"
    memory_size="$(
        grep -o -E '[0-9]+' <<< "${memory_used}"
    )"
    memory_type="$(
        grep -o -E '[A-Z]{0,3}' <<< "${memory_used}"
    )"
    string_ansi="$(
        _o_text "${format_comp}" \
            "$(
                _o_text "${format_info}" \
                    "$(_o_ansi_clear; _o_fg_light_gray; _o_style_dim)" \
                    "$(_o_style_bold)" \
                    "${USER}" \
                    "$(hostname -s)" \
                    "$(_o_ansi_clear; _o_fg_light_gray; _o_style_dim)" \
                    "$(_o_ansi_clear)"
            )" \
            "$(
                _o_text "${format_used}" \
                    "$(_o_fg_dark_gray; _o_style_dim)" \
                    "$(_o_fg_dark_gray)" \
                    "$(
                        _get_unix_time_diff \
                            "${_DZ_LOAD_TIME}" \
                            "$(_get_microtime)"
                    )" \
                    "$(
                        LC_NUMERIC=en_US printf "%'.f\n" "${memory_size}"
                    )" \
                    "${memory_type}" \
                    "$(_o_fg_dark_gray; _o_style_dim)" \
                    "$(_o_ansi_clear)"
            )" \
            "$(_o_fg_light_gray; _o_style_dim)" \
            "$(_o_ansi_clear)" \
            "$(
                _o_text "${format_stat}" \
                    "$(_o_fg_green; _o_bg_black; _o_style_invert; _o_style_bold)" \
                    "${string_stat}" \
                    "$(_o_ansi_clear)"
            )"
    )"

    string_none=$(_o_ansi_al_sequence_remove "${string_ansi}")
    padding_len=$(($(_terminal_dims_w) - ${#string_none} - 2))

    _o_nl
    _o_padding ${padding_len}
    _o_line "${string_ansi}"
    _o_ansi_clear
}


#
# manage progress loader state configuration for terminal info
#

function _o_progress_cfg_state_setup_terminal_info {
    typeset -g _DZ_LOADER_COL_MAX=$(_terminal_dims_w)
    typeset -g _DZ_LOADER_COL_POS=${_DZ_LOADER_COL_POS:-0}
}


#
# manage progress loader state configuration for loader action type
#

function _o_progress_cfg_state_setup_loader_action {
    typeset -g _DZ_LOADER_STARTED=${_DZ_LOADER_STARTED:-0}
    typeset -g _DZ_LOADER_DISABLE=${_DZ_LOADER_DISABLE:-0}
    typeset -g _DZ_LOADER_CLEARED=${_DZ_LOADER_CLEARED:-0}
}


#
# manage progress loader state configuration
#

function _o_progress_cfg_state_setup {
    _o_progress_cfg_state_setup_terminal_info
    _o_progress_cfg_state_setup_loader_action
}


#
# manage progress loader state configuration for terminal info
#

function _o_progress_cfg_state_reset_terminal_info {
    typeset -g _DZ_LOADER_COL_MAX=$(_terminal_dims_w)
    typeset -g _DZ_LOADER_COL_POS=0
}


#
# manage progress loader state configuration for loader action type
#

function _o_progress_cfg_state_reset_loader_action {
    typeset -g _DZ_LOADER_STARTED=0
    typeset -g _DZ_LOADER_DISABLE=0
    typeset -g _DZ_LOADER_CLEARED=1
}


#
# manage progress loader state configuration
#

function _o_progress_cfg_state_reset {
    _o_progress_cfg_state_reset_terminal_info
    _o_progress_cfg_state_reset_loader_action
}


#
# manage progress loader state configuration
#

function _o_progress_cfg_state_close {
    _o_progress_cfg_state_setup
    _DZ_LOADER_DISABLE=1
}


#
# manage progress loader state configuration
#

function _o_progress_cfg_state_clear {
    _o_progress_cfg_state_setup
    _DZ_LOADER_CLEARED=0
}


#
# manage progress loader state configuration
#

function _o_progress_cfg_state_start {
    _o_progress_cfg_state_clear
    _DZ_LOADER_STARTED=1
}


#
# Define fancy complete message display function.
#

function _o_progress_close {
    local reset="${1:-0}"

    _o_progress_cfg_state_setup

    if [[ ${_DZ_LOADER_STARTED} -eq 1 ]] && [[ ${_DZ_LOADER_DISABLE} -ne 1 ]]; then
        _o_progress_write_step_char_term && sleep 0.75 && reset=1
    fi

    [[ ${reset} -eq 1 ]] && _o_progress_reset

    _o_progress_cfg_state_close
}


#
# Define fancy complete message display function.
#

function _o_progress_reset {
    _o_progress_cfg_state_setup

    if [[ ${_DZ_LOADER_STARTED} -eq 1 ]] && [[ ${_DZ_LOADER_DISABLED} -eq 0 ]] && [[ ${_DZ_LOADER_CLEARED} -eq 0 ]]; then
        clear
    fi

    _o_progress_cfg_state_reset
}


function _o_progress_tracked_write_step_section {
    local frmt="%s%s%s"
    local text="${1}"

    _o_progress_tracked_write_text \
        "${frmt}" \
        "$(_o_ansi_clear; _o_fg_dark_gray; _o_style_dim)" \
        "${text}" \
        "$(_o_ansi_clear)"
}


function _o_progress_tracked_write_nl {
    _o_progress_cfg_state_reset_terminal_info
    _o_nl
}


function _o_progress_tracked_write_text {
    local text

    text="$(_o_text "${@}")"
    _DZ_LOADER_COL_POS=$(( ${_DZ_LOADER_COL_POS} + $(_str_length "${text}" "false") ))

    _o_text "${text}"
}


function _o_progress_tracked_write_pads {
    local size="${1}"

    _o_padding ${size}
    _DZ_LOADER_COL_POS=$(( ${_DZ_LOADER_COL_POS} + ${size} ))
}


#
# Output load progress step indicator
#

function _o_progress_write_step_section {
    local text="${1}"
    local incs="${2:-true}"

    if [[ ${incs} == "true" ]] && [[ ${_DZ_LOADER_COL_POS} -ge $(( ${_DZ_LOADER_COL_MAX} - 3 )) ]]; then
        _o_progress_write_step_char_term "false"
        _o_progress_write_step_text
    fi

    _o_progress_tracked_write_step_section "${text}"
}


#
# Write progress iteration step character: initializing (first) character
#

function _o_progress_write_step_char_init {
    _o_progress_write_step_section "["
}


#
# Write progress iteration step character: terminating (last) character
#

function _o_progress_write_step_char_term {
    _o_progress_write_step_section "] " "${1:-true}"
}


#
# Write progress iteration step character
#

function _o_progress_write_step_char {
    _o_progress_write_step_section "—"
}


#
# Write progress iteration step "loading" text
#

function _o_progress_write_step_text {
    local cont="${1:-false}"
    local frmt="  %s %' 7s %s  "
    local text="loading"

    _o_progress_tracked_write_nl
    _o_progress_tracked_write_text \
        "${frmt}" \
        "$(_o_fg_dark_gray; _o_bg_black; _o_style_invert; _o_style_bold; _o_style_dim)" \
        "${text:u}" \
        "$(_o_ansi_clear)"
    _o_progress_write_step_char_init
    _o_progress_write_step_char
    _o_progress_write_step_char
    _o_progress_write_step_char
}


#
# Write progress loading information
#

function _o_progress_write {
    _o_progress_cfg_state_setup

    if [[ ${_DZ_LOADER_DISABLE} -eq 1 ]]; then
        return
    fi

    _o_progress_cfg_state_clear

    if [[ ${_DZ_LOADER_STARTED} -eq 1 ]]; then
        _o_progress_write_step_char
    else
        _o_progress_write_step_text
        _o_progress_cfg_state_start
    fi
}
