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
    return
    local indent="${1}"; shift
    local string

    if [[ -z ${_DZ_IO_BUFF_LINES} ]]; then
        typeset -g _DZ_IO_BUFF_LINES=()
    fi

    if [[ -z ${_DZ_LOG_BUFFER_LINES} ]]; then
        typeset -g _DZ_LOG_BUFFER_LINES=()
    fi

    for line in "${@}"; do
        string="$(_format_buffer ${indent} "${line}")"
        _DZ_IO_BUFF_LINES+=("${string}")
        _DZ_LOG_BUFFER_LINES+=("${string}")
    done
}
