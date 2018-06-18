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
# Define function to return microsecond aware unix time.
#
function _getPreciseUnixTime {
    echo -n $(date +%s.%N)
}


#
# Get the start time so we can profile performnce start to end.
#

_DOT_ZSH_LOAD_TIME_START=$(_getPreciseUnixTime)


#
# Enable shell-debugging and/or profiler from generic env variables.
#

if [[ ${ZSH_DEBUG+x}   ]]; then
    set -x
fi
if [[ ${ZSH_PROFILE+x} ]]; then
    ZSH_PROFILE=1
fi


#
# Hard-code our LANG.
#
LANG=en_US.UTF-8


#
# Define vars for script name, script dir path, and complete script file path.
#

D_ZSH_NAME=${(%):-%x}
D_ZSH_BASE=$(basename ${D_ZSH_NAME})
D_ZSH_PATH=${HOME}/.dot-zsh
D_ZSH_CFG_ENABL_PATH=${D_ZSH_PATH}/confs-enabled
D_ZSH_INC_VARIABLES="${D_ZSH_PATH}/incs-common/env-define-variables.zsh"
D_ZSH_INC_FUNCTIONS="${D_ZSH_PATH}/incs-common/env-define-functions.zsh"


#
# Source requires variables assignments and function definitions
#
for f in "${D_ZSH_INC_VARIABLES}" "${D_ZSH_INC_FUNCTIONS}"; do
    if [[ ! -r "${f}" ]]; then
        printf "Required file include is not readable or does not exist: %s" \
            "${f}"
        exit 255
    fi

    source "${f}"
done


#
# Set print mode to log to buffer until config is loaded.
#

if [[ ! ${D_ZSH_STIO_BUFF+x} ]]; then
    D_ZSH_STIO_BUFF=-1
fi


#
# Assign verbosity if variable is unset.
#

if [[ ! ${D_ZSH_STIO_VLEV+x} ]]; then
    D_ZSH_STIO_VLEV=-5;
fi


#
# Assign verbosity using common variables
#

if [[ ${VERBOSE+x} ]]; then
    D_ZSH_STIO_VLEV=2
fi

if [[ ${VERY_VERBOSE+x} ]]; then
    D_ZSH_STIO_VLEV=4
fi

if [[ ${DEBUG+x} ]]; then
    D_ZSH_STIO_VLEV=10
fi


#
# Let the user know we've begun and provide some environment context
#

_topLog 3 '--> Initializing loader script ...'
_topLog 3 '    --> PROJECT NAME ............ %s' "dot-zsh"
_topLog 3 '    --> PRIMARY AUTHOR .......... %s' "$(_dotZshWhos)"
_topLog 3 '    --> RELEASE VERSION ......... %s' "$(_dotZshVers)"
_topLog 3 '    --> GIT REMOTE .............. %s' "$(_dotZshRepo)"
_topLog 3 '    --> GIT REFERENCE ........... %s' "$(_dotZshTag)"
_topLog 3 '    --> GIT COMMIT .............. %s' "$(_dotZshHash)"

_topLog 3 '--> Resolved runtime configuration ...'
_topLog 3 '    --> LOADER SCRIPT PATH ...... %s' "$(_dotZshLoad)"
_topLog 3 '    --> PRIOR SHELL BIN PATH .... %s' "$(_dotZshParseShellPath)"
_topLog 3 '    --> FOUND ZSH BIN PATH ...... %s' "$(_dotZshParseZshPath)"
_topLog 3 '    --> FOUND ZSH VERSION ....... %s' "$(_dotZshParseZshVers)"

#
# Load our configuration files.
#

_topLog 1 "--> Loading configuration file(s) from ${D_ZSH_CFG_ENABL_PATH} ..."

for f in ${D_ZSH_CFG_ENABL_PATH}/??-???-*.zsh; do
    [[ ! -f "${f}" ]] && \
        _topLog 1 "    --> Failed to source $(basename ${f})" && \
        continue

    _topLog 1 "    --> Sourcing file $(basename ${f})" && \
        source "${f}"
done


#
# Source all enabled includes by int-prefix order.
#

_topLog 1 \
    "--> Loading enabled include files(s) from ${D_ZSH_INC_ENABL_PATH} ..."

for f in ${D_ZSH_INC_ENABL_PATH}/??-???-*.zsh; do
    [[ ! -f "${f}" ]] && \
        _topLog 1 "    --> Failed to source $(basename ${f})" && \
        continue

    _topLog 1 "    --> Sourcing file $(basename ${f})" && \
        source "${f}"
done

#
# Generate completion message (can't be done after unsetting vars/functions)
#

_DOT_ZSH_DONE_MESSAGE="$(_dotZshWriteFancyComplete)"


#
# Cleanup variables, functions, etc
#

_topLog 1 "--> Performing final cleanup pass ..."
_actLog "Unsetting global variables defined by this script ..." 1

for v in ${D_ZSH_UNSET_VS[@]}; do
    eval "unset ${v}" && _actLog "Variable unset '${v}'"
done

_actLog "Unsetting global functions defined by this script ..." 1

for f in ${D_ZSH_UNSET_FS[@]}; do
    _actLog "Function unset '${f}'"
done

for f in ${D_ZSH_UNSET_FS[@]}; do
    eval "unset -f ${f}"
done


#
# Write completion message if verbosity high enough
#

[[ ${D_ZSH_STIO_VLEV:--5} == -5 ]] && echo -en "${_DOT_ZSH_DONE_MESSAGE}"
