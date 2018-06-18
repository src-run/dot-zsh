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

function _getDifferenceBetweenUnixTimes {
    local time_start="${1}"
    local time_ended="${2}"

    printf '%.5f' $((${time_ended} - ${time_start}))
}


#
# create ANSI color sequence with optional style
#
function _ansiColor {
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
function _ansiClear {
    echo -n "\e[0m"
}


#
# enable styling attributes: bold, dim, underline, blink, invert, and hide
#
function _styleBold {
    echo -n "\e[1m"
}

function _styleDim {
    echo -n "\e[2m"
}

function _styleUnderline {
    echo -n "\e[4m"
}

function _styleBlink {
    echo -n "\e[5m"
}

function _styleInvert {
    echo -n "\e[7m"
}

function _styleHide {
    echo -n "\e[8m"
}

function _styleStrikeout {
    echo -n "\e[9m"
}


#
# output foreground ANSI color sequence
#
function _fgDefault {
    echo -n $(_ansiColor 39 "${1}")
}

function _fgBlack {
    echo -n $(_ansiColor 30 "${1}")
}

function _fgRed {
    echo -n $(_ansiColor 31 "${1}")
}

function _fgGreen {
    echo -n $(_ansiColor 32 "${1}")
}

function _fgYellow {
    echo -n $(_ansiColor 33 "${1}")
}

function _fgBlue {
    echo -n $(_ansiColor 34 "${1}")
}

function _fgMagenta {
    echo -n $(_ansiColor 35 "${1}")
}

function _fgCyan {
    echo -n $(_ansiColor 36 "${1}")
}

function _fgLightGray {
    echo -n $(_ansiColor 37 "${1}")
}

function _fgDarkGray {
    echo -n $(_ansiColor 90 "${1}")
}

function _fgLightRed {
    echo -n $(_ansiColor 91 "${1}")
}

function _fgLightGreen {
    echo -n $(_ansiColor 92 "${1}")
}

function _fgLightYellow {
    echo -n $(_ansiColor 93 "${1}")
}

function _fgLightBlue {
    echo -n $(_ansiColor 94 "${1}")
}

function _fgLightMagenta {
    echo -n $(_ansiColor 95 "${1}")
}

function _fgLightCyan {
    echo -n $(_ansiColor 96 "${1}")
}

function _fgWhite {
    echo -n $(_ansiColor 97 "${1}")
}


#
# output background ANSI color sequence
#
function _bgDefault {
    echo -n $(_ansiColor 49 "${1}")
}

function _bgBlack {
    echo -n $(_ansiColor 40 "${1}")
}

function _bgRed {
    echo -n $(_ansiColor 41 "${1}")
}

function _bgGreen {
    echo -n $(_ansiColor 42 "${1}")
}

function _bgYellow {
    echo -n $(_ansiColor 43 "${1}")
}

function _bgBlue {
    echo -n $(_ansiColor 44 "${1}")
}

function _bgMagenta {
    echo -n $(_ansiColor 45 "${1}")
}

function _bgCyan {
    echo -n $(_ansiColor 46 "${1}")
}

function _bgLightGray {
    echo -n $(_ansiColor 47 "${1}")
}

function _bgDarkGray {
    echo -n $(_ansiColor 100 "${1}")
}

function _bgLightRed {
    echo -n $(_ansiColor 101 "${1}")
}

function _bgLightGreen {
    echo -n $(_ansiColor 102 "${1}")
}

function _bgLightYellow {
    echo -n $(_ansiColor 103 "${1}")
}

function _bgLightBlue {
    echo -n $(_ansiColor 104 "${1}")
}

function _bgLightMagenta {
    echo -n $(_ansiColor 105 "${1}")
}

function _bgLightCyan {
    echo -n $(_ansiColor 106 "${1}")
}

function _bgWhite {
    echo -n $(_ansiColor 107 "${1}")
}


#
# remove all ANSI SGR and EL escape sequences
#
function _rmAnsiSgrEl {
    echo "${1}" | sed -r "s/\x1b\[([0-9]{1,2}(;[0-9]{1,2})*)?m//g"
}


#
# Define simple file logger function.
#

function _wrtLog {
    typeset -g b_flog

    local d="${1}" ; shift
    local l="${1}" ; shift
    local c="${1}" ; shift
    local m="${1}" ; shift
    local p

    p="$(printf '[%s:%s]' ${c} ${d})"
    b_flog+=("${p} $(printf ${m} "$@")")

    if [[ "${D_ZSH_STIO_BUFF:=0}" -eq 0 ]] && [[ ${D_ZSH_LOGS_PATH:-x} ]] && [[ "${#b_flog}" -gt 0 ]]; then
        for b in "${b_flog[@]}"; do
            echo "${b}" | tee -a "${D_ZSH_LOGS_PATH}" &> /dev/null
        done

        b_flog=()
    fi
}


#
# Define simple top-level std out logger function.
#

function _topLog {
    typeset -g b_top_sout

    local d
    local m
    local c="$USER/dot-zsh"
    local l="${1}" ; shift

    d=$(date +%s)
    m="$(echo ${1} | sed 's/[ ]*$//g')" ; shift

    if [[ ! "${m}" ]]; then
        return
    fi

    _wrtLog "${d}" "${l}" "${c}" "${m}" "$@"

    (( D_ZSH_STIO_VLEV < l )) || \
        b_top_sout+=("$(printf '[%s:%s] '${m} ${c} ${d} "$@")")

    if [[ "${D_ZSH_STIO_BUFF:=0}" -eq 0 ]]; then
        for line in "${b_top_sout[@]}"; do
            [[ "${line}" ]] && echo "$line"
        done

        b_top_sout=()
    fi
}


#
# String padding routine.
#

function _indent {
    for i in `seq 1 ${1:-2}`; do
        echo -n "    "
        #padding="    ${padding}"
    done

    #echo "${padding}"
}


#
# Define simple log notice.
#

function _dzsh_warning {
    local d
    local c="$USER/dot-zsh"
    local m="!!! WARNING: $(echo ${1} | sed 's/[ ]*$//g')" ; shift
    local l="${1:-2}"

    d=$(date +%s)

    _wrtLog "${d}" "${l}" "${c}" "$(_indent ${l})${m}" "$@"

    typeset -g b_warn_sout
    b_warn_sout+=("$(printf '[%s:%s] '${m} ${c} ${d} "$@")")

    if [[ "${D_ZSH_STIO_BUFF:=0}" -eq 0 ]]; then
        for line in "${b_warn_sout[@]}"; do
            [[ "${line}" ]] && >&2 echo "$line"
        done

        b_warn_sout=()
    fi
}


#
# Define self repo name (from dir path) resolver function.
#

function _dotZshRepoByPath {
    echo "$(basename "$(cd ${D_ZSH_PATH} && git rev-parse --show-toplevel)")"
}


#
# Define self repo name (from git remote) resolver function.
#

function _dotZshRepoByRemote {
    echo "$(cd ${D_ZSH_PATH} && git remote get-url origin | sed 's/https\?:\/\///')"
}


#
# Checks if git has pending changes (is dirty tree)
#

function _dotZshParseGitDirty {
    git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && \
        echo "*"
}


#
# Gets the current git branch
#

function _dotZshParseGitBranch {
    export D_ZSH_SELF_GIT_BRANCH
    local desc_dirty
    local show_dirty="${1:-0}"
    local postfix=""

    desc_dirty="$(_dotZshParseGitDirty)"

    if [[ "${show_dirty}" == "1" ]]; then
        postfix="${desc_dirty}"
        unset D_ZSH_SELF_GIT_BRANCH
    fi

    if [[ "${show_dirty}" == "0" ]] && [[ "$(echo "${D_ZSH_SELF_GIT_BRANCH}" | awk '{print substr($0,length,1)}')" == "*" ]]; then
        unset D_ZSH_SELF_GIT_BRANCH
    fi

    if [[ ${D_ZSH_SELF_GIT_BRANCH:-x} == "x" ]]; then
        D_ZSH_SELF_GIT_BRANCH="$(cd ${D_ZSH_PATH} && git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1${postfix}/" 2> /dev/null)"
    fi

    echo "${D_ZSH_SELF_GIT_BRANCH}"
}


#
# Get last commit hash prepended with @ (i.e. @8a323d0)
#
function _dotZshParseGitHash {
    export D_ZSH_SELF_COMMIT
    local prepend="${1:-0}"
    local prefix=""

    if [[ "${prepend}" == "1" ]]; then
        prefix="@"
        unset D_ZSH_SELF_COMMIT
    fi

    if [[ "${prepend}" == "0" ]] && [[ "${D_ZSH_SELF_COMMIT:0:1}" == "@" ]]; then
        unset D_ZSH_SELF_COMMIT
    fi

    if [[ ${D_ZSH_SELF_COMMIT:-x} == "x" ]]; then
        D_ZSH_SELF_COMMIT="$(cd ${D_ZSH_PATH} && git rev-parse HEAD 2> /dev/null | sed "s/\(.*\)/${prefix}\1/" 2> /dev/null)"
    fi

    echo "${D_ZSH_SELF_COMMIT}"
}


#
# Get the tag name if we're on one
#

function _dotZshParseGitTag {
    local always="${1:-0}"
    export D_ZSH_SELF_TAG

    if [[ ${D_ZSH_SELF_TAG:-x} == "x" ]]; then
        D_ZSH_SELF_TAG="$(cd ${D_ZSH_PATH} && git describe --exact-match ${s} HEAD 2> /dev/null)"
    fi

    if [[ ${D_ZSH_SELF_TAG:-x} == "x" ]] && [[ "${always}" ]]; then
        D_ZSH_SELF_TAG="$(cd ${D_ZSH_PATH} && git describe --all ${s} HEAD 2> /dev/null)"
    fi

    echo "${D_ZSH_SELF_TAG}"
}


#
# Define self repo name resolver function.
#

function _dotZshRepo {
    export D_ZSH_SELF_REPO
    local -a strategies=("_dotZshRepoByRemote" "_dotZshRepoByPath")

    if [[ ${D_ZSH_SELF_REPO:-x} == "x" ]]; then
        for s in "${strategies[@]}"; do
            D_ZSH_SELF_REPO="$(eval "${s}")" && [[ ${#D_ZSH_SELF_REPO} -gt 1 ]] && break
        done
    fi

    echo "${D_ZSH_SELF_REPO}"
}


#
# Define self author resolver function.
#

function _dotZshWhos {
    export D_ZSH_SELF_WHOS

    if [[ ${D_ZSH_SELF_WHOS:-x} == "x" ]]; then
        D_ZSH_SELF_WHOS="$(cd ${D_ZSH_PATH} && git shortlog -ne | head -n1 | grep -o -P '^[^\(]+' | sed 's/ *$//')"
    fi

    echo "${D_ZSH_SELF_WHOS}"
}


#
# Define self version resolver function.
#

function _dotZshTag {
    export D_ZSH_SELF_TAG
    local -a strategies=("--exact-match" "--always")

    if [[ ${D_ZSH_SELF_TAG:-x} == "x" ]]; then
        D_ZSH_SELF_TAG="$(_dotZshParseGitTag)"
    fi

    echo "${D_ZSH_SELF_TAG}"
}


#
# Define self version resolver function.
#

function _dotZshVers {
    export D_ZSH_SELF_VERS
    local -a strategies=("--exact-match" "--always")

    if [[ ${D_ZSH_SELF_VERS:-x} == "x" ]]; then
        for s in "${strategies[@]}"; do
            D_ZSH_SELF_VERS="$(cd ${D_ZSH_PATH} && git describe --tag ${s} HEAD 2> /dev/null)" && [[ ${#D_ZSH_SELF_VERS} -gt 4 ]] && break
        done

        if [[ "$(_dotZshParseGitDirty)" == "*" ]]; then
            D_ZSH_SELF_VERS="${D_ZSH_SELF_VERS} (dirty)"
        fi
    fi

    echo "${D_ZSH_SELF_VERS}"
}


#
# Define self commit resolver function.
#

function _dotZshHash {
    export D_ZSH_SELF_HASH
    local -a strategies=("--exact-match" "--always")

    if [[ ${D_ZSH_SELF_HASH:-x} == "x" ]]; then
        D_ZSH_SELF_HASH="$(_dotZshParseGitHash)"
    fi

    echo "${D_ZSH_SELF_HASH}"
}


#
# Define zsh name resolver function.
#

function _dotZshLoad {
    echo "${D_ZSH_NAME}"
}


#
# Define shell path resolver function.
#

function _dotZshParseShellPath {
    echo "${SHELL}"
}


#
# Define zsh path resolver function.
#

function _dotZshParseZshPath {
    D_ZSH_ZSH_PATH="$(which zsh 2> /dev/null)"

    if [[ ${#D_ZSH_ZSH_PATH} -lt 3 ]]; then
        _dzsh_warning "Failed to determine installed ZSH binary path!"
    fi

    echo "${D_ZSH_ZSH_PATH}"
}


#
# Define zsh version resolver function.
#

function _dotZshParseZshVers {
    D_ZSH_ZSH_VERSION="$(apt-cache show zsh 2> /dev/null | grep -E -o '^Version: .+' 2> /dev/null | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+(-.+)?' 2> /dev/null)"

    if [[ ${#D_ZSH_ZSH_VERSION} -lt 5 ]]; then
        local zsh_path="$(_dotZshParseShellPath)"

        if [[ ${#zsh_path} -gt 2 ]]; then
            D_ZSH_ZSH_VERSION="$(${zsh_path} --version | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+(\s\([^)]+\))?' 2> /dev/null)"
        fi
    fi

    if [[ ${#D_ZSH_ZSH_VERSION} -lt 5 ]]; then
        _dzsh_warning "Failed to determine installed ZSH binary version!"
    fi

    echo "${D_ZSH_ZSH_VERSION}"
}


function _profGetPrecTime {
    echo $(date +%s%N | cut -b1-13)
}


function _profClear {
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

function _profStart {
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

    _PROF_S[$name]=$(_profGetPrecTime)
}

function _profEnd {
    typeset -Ag _PROF_S
    typeset -Ag _PROF_E
    local name="${1:-main}"

    if [[ ! ${_PROF_S[$name]} ]]; then
        _profClear ${name}
        return
    fi

    _PROF_E[$name]=$(_profGetPrecTime)
}

function _profDiff {
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
        _profClear ${name}
        return
    fi

    s=${_PROF_S[$name]}
    e=${_PROF_E[$name]}

    ${_PROF_D[$name]}=$(bc <<< "scale=4; ( ${e} - ${s} ) / 1000")

    echo ${_PROF_D[$name]}
}


#
# Define fancy complete message display function.
#

function _dotZshWriteFancyComplete {
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
            "$(_ansiClear; _fgLightGray; _styleDim)" \
            "$(_styleBold)" \
            "${USER}" \
            "$(hostname -s)" \
            "$(_ansiClear; _fgLightGray; _styleDim)" \
            "$(_ansiClear)"
    )"

    text_time="$(
        printf "${frmt_time}" \
            "$(_fgDarkGray; _styleDim)" \
            "$(_fgDarkGray)" \
            "$(
                _getDifferenceBetweenUnixTimes \
                    "${_DOT_ZSH_LOAD_TIME_START}" \
                    "$(_getPreciseUnixTime)"
            )" \
            "$(_fgDarkGray; _styleDim)" \
            "$(_ansiClear)"
    )"

    text_stat="$(
        printf "${frmt_stat}" \
            "$(_fgGreen; _bgBlack; _styleInvert; _styleBold)" \
            "${text_stat}" \
            "$(_ansiClear)"
    )"

    text_comp="$(
        printf "%s %s $(_fgLightGray; _styleDim)...$(_ansiClear) %s" \
            "${text_desc}" \
            "${text_time}" \
            "${text_stat}"
    )"

    text_comp_no_seq=$(_rmAnsiSgrEl "${text_comp}")
    pre_pad=$((${columns} - ${#text_comp_no_seq} - 1))

    _ansiClear
    echo -en "\n"

    if [[ ${pre_pad} -gt 0 ]]; then
        for i in $(seq 1 ${pre_pad}); do
            echo -en ' '
        done
    fi

    echo -en "${text_comp}\n" && \
        _ansiClear
}


#
# Define simple logger for include files.
#

function _incLog {
    local i="$1" ; shift ; local l="$1" ; shift ; local m="$1" ; shift

    _topLog "${l}" "$(_indent ${i})--> ${m}" "$@"
}


#
# Define simple logger for include files.
#

function _actLog {
    local m="${1}" ; shift ; local i="${1:-2}"

    if [[ "${1}" != "" ]]; then
        shift
    fi

    _topLog 4 "$(_indent ${i})--- ${m}" "$@"
}


#
# Define simple log warning.
#

function _warning {
    typeset -g b_warn_sout


    local c="!!WARNING!!"
    local l=2
    local m="$1"
    local d
    local w

    shift

    d=$(date +%s)
    w="$(printf ${m} "$@")"

    b_warn_sout+=("${w}")

    if [[ "${D_ZSH_STIO_BUFF:=0}" -eq 0 ]]; then
        for line in "${b_warn_sout[@]}"; do
            if [[ ! ${line} ]]; then
                continue;
            fi

            >&2 echo -en "\n!!\n!! WARNING\n!!"
            >&2 echo " Message: \"${line}\""
            >&2 echo -en "!!\n\n"
        done

        b_warn_sout=()
    fi

    _wrtLog "${d}" "${l}" "${c}" "$(_indent ${l})--> ${m}"
}


#
# Add passed directory to environment PATH variable
#

function _dotZshPathVariableAddition {
    local p
    local t

    p=$(zsh -c "echo ${1}")
    t="${2:-default}"

    if [[ -d "${p}" ]] && [[ ":$PATH:" != *":${p}:"* ]]; then
        PATH="${p}:${PATH}" && \
            _incLog 2 2 "Prefixed 'PATH' with ${p} (${t})"
    fi
}


#
# Add temporary request for environment PATH addition
#

function _dotZshPathVariableAdditionRequest {
    local p="${1}"

    if [[ ! -f "${D_ZSH_PATH_SCRIPTED_FILE}" ]]; then
        touch "${D_ZSH_PATH_SCRIPTED_FILE}" &> /dev/null
    fi

    echo "${p}" >> "${D_ZSH_PATH_SCRIPTED_FILE}" &> /dev/null
}


#
# Cleanup temporary environment PATH file
#

function _dotZshPathVariableAdditionRequestCleanup {
    if [[ -f "${D_ZSH_PATH_SCRIPTED_FILE}" ]]; then
        rm "${D_ZSH_PATH_SCRIPTED_FILE}" &> /dev/null
    fi
}


#
# Setup and assign the ssh aliases via the configured variables
#

function _dotZshSshAliasAssigments {
    local prefixes=( "ssh-" "s-" "" )
    local name
    local host
    local port
    local user
    local opts
    local wait
    local opts_desc
    local alias_key
    local alias_val

    for name in "${(@k)D_ZSH_SSH_ALIAS_HOST}"; do
        host="${D_ZSH_SSH_ALIAS_HOST[$name]}"
        port=22
        user='rmf'
        opts='-y -v'
        wait=1.0

        if [[ "${D_ZSH_SSH_ALIAS_PORT[$name]}" != "" ]]; then
            port="${D_ZSH_SSH_ALIAS_PORT[$name]}"
        fi

        if [[ "${D_ZSH_SSH_ALIAS_USER[$name]}" != "" ]]; then
            user="${D_ZSH_SSH_ALIAS_USER[$name]}"
        fi

        if [[ "${D_ZSH_SSH_ALIAS_OPTS[$name]}" != "" ]]; then
            opts="${D_ZSH_SSH_ALIAS_OPTS[$name]}"
        fi

        if [[ "${D_ZSH_SSH_ALIAS_WAIT[$name]}" != "" ]]; then
            wait="${D_ZSH_SSH_ALIAS_WAIT[$name]}"
        fi

        opts_desc="${opts}"
        [[ -z "${opts_desc}" ]] && opts_desc="null"

        for prefix in "${prefixes[@]}"; do
            alias_key="${prefix}${name}"
            alias_val="$(
                _dotZshSshAliasBuildCommand \
                    "${name}" \
                    "${user}" \
                    "${host}" \
                    "${port}" \
                    "${opts}" \
                    "${wait}"
            )"

            if ( which "${alias_key}" &> /dev/null ); then
                continue && \
                    _actLog "Alias skipped (name exists) "\
                        "'${alias_key}=\"${alias_val}\"'"
            fi

            alias $alias_key="${alias_val}" &> /dev/null && \
                _actLog "Alias defined '${alias_key}=\"${alias_val}\"'"
        done
    done
}


#
# Build SSH connection alias command
#

function _dotZshSshAliasBuildCommand {
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


# EOF
