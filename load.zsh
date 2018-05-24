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
# Get the start time so we can profile performnce start to end.
#

D_ZSH_TIME_START=$(date +%s%N | cut -b1-13)


#
# Enable shell-debugging and/or profiler from generic env variables.
#

if [[ ${ZSH_DEBUG+x}   ]]; then; set -x;        fi
if [[ ${ZSH_PROFILE+x} ]]; then; ZSH_PROFILE=1; fi


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


#
# Define simple file logger function.
#

function _wrtLog() {
  typeset -g b_flog

  local d="${1}" ; shift
  local l="${1}" ; shift
  local c="${1}" ; shift
  local m="${1}" ; shift
  local p="$(printf '[%s:%s]' ${c} ${d})"

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

function _topLog() {
  typeset -g b_top_sout

  local d=$(date +%s)
  local c="$USER/dot-zsh"
  local l="${1}" ; shift
  local m="$(echo ${1} | sed 's/[ ]*$//g')" ; shift

  if [[ ! "${m}" ]]; then
    return
  fi

  _wrtLog "${d}" "${l}" "${c}" "${m}" "$@"

  (( D_ZSH_STIO_VLEV < l )) || b_top_sout+=("$(printf '[%s:%s] '${m} ${c} ${d} "$@")")

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

function _indent() {
  local depth="${1:-2}" ; local padding

  for i in `seq 1 ${depth}`; do padding="    ${padding}"; done
  echo "${padding}"
}


#
# Define simple log notice.
#

function _dzsh_warning() {
  typeset -g b_warn_sout

  local d=$(date +%s)
  local c="$USER/dot-zsh"
  local m="!!! WARNING: $(echo ${1} | sed 's/[ ]*$//g')" ; shift
  local l="${1:-2}"

  _wrtLog "${d}" "${l}" "${c}" "$(_indent ${l})${m}" "$@"

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

function _dotZshRepoByPath() {
  echo "$(basename "$(cd ${D_ZSH_PATH} && git rev-parse --show-toplevel)")"
}


#
# Define self repo name (from git remote) resolver function.
#

function _dotZshRepoByRemote() {
  local remote="$(cd ${D_ZSH_PATH} && git remote get-url origin | sed 's/https\?:\/\///')"

  echo "${remote:0:-4}"
}


#
# Checks if git has pending changes (is dirty tree)
#

function _dotZshParseGitDirty() {
  git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo "*"
}


#
# Gets the current git branch
#

function _dotZshParseGitBranch() {
  export D_ZSH_SELF_GIT_BRANCH
  local show_dirty="${1:-0}"
  local desc_dirty="$(_dotZshParseGitDirty)"
  local postfix=""

  if [[ "${show_dirty}" == "1" ]]; then postfix="${desc_dirty}"; unset D_ZSH_SELF_GIT_BRANCH; fi
  if [[ "${show_dirty}" == "0" ]] && [[ "$(echo "${D_ZSH_SELF_GIT_BRANCH}" | awk '{print substr($0,length,1)}')" == "*" ]]; then unset D_ZSH_SELF_GIT_BRANCH; fi

  if [[ ${D_ZSH_SELF_GIT_BRANCH:-x} == "x" ]]; then
    D_ZSH_SELF_GIT_BRANCH="$(cd ${D_ZSH_PATH} && git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1${postfix}/" 2> /dev/null)"
  fi

  echo "${D_ZSH_SELF_GIT_BRANCH}"
}


#
# Get last commit hash prepended with @ (i.e. @8a323d0)
#
function _dotZshParseGitHash() {
  export D_ZSH_SELF_COMMIT
  local prepend="${1:-0}"
  local prefix=""

  if [[ "${prepend}" == "1" ]]; then prefix="@"; unset D_ZSH_SELF_COMMIT; fi
  if [[ "${prepend}" == "0" ]] && [[ "${D_ZSH_SELF_COMMIT:0:1}" == "@" ]]; then unset D_ZSH_SELF_COMMIT; fi

  if [[ ${D_ZSH_SELF_COMMIT:-x} == "x" ]]; then
    D_ZSH_SELF_COMMIT="$(cd ${D_ZSH_PATH} && git rev-parse HEAD 2> /dev/null | sed "s/\(.*\)/${prefix}\1/" 2> /dev/null)"
  fi
  
  echo "${D_ZSH_SELF_COMMIT}"
}


#
# Get the tag name if we're on one
#

function _dotZshParseGitTag() {
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

function _dotZshRepo() {
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

function _dotZshWhos() {
  export D_ZSH_SELF_WHOS

  if [[ ${D_ZSH_SELF_WHOS:-x} == "x" ]]; then
    D_ZSH_SELF_WHOS="$(cd ${D_ZSH_PATH} && git shortlog -ne | head -n1 | grep -o -P '^[^\(]+' | sed 's/ *$//')"
  fi

  echo "${D_ZSH_SELF_WHOS}"
}


#
# Define self version resolver function.
#

function _dotZshTag() {
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

function _dotZshVers() {
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

function _dotZshHash() {
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

function _dotZshLoad() {
  echo "${D_ZSH_NAME}"
}


#
# Define shell path resolver function.
#

function _dotZshParseShellPath() {
  echo "${SHELL}"
}


#
# Define zsh path resolver function.
#

function _dotZshParseZshPath() {
  D_ZSH_ZSH_PATH="$(which zsh 2> /dev/null)"

  if [[ ${#D_ZSH_ZSH_PATH} -lt 3 ]]; then
    _dzsh_warning "Failed to determine installed ZSH binary path!"
  fi

  echo "${D_ZSH_ZSH_PATH}"
}


#
# Define zsh version resolver function.
#

function _dotZshParseZshVers() {
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


function _profGetPrecTime()
{
  echo $(date +%s%N | cut -b1-13)
}


function _profClear()
{
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

function _profStart()
{
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

function _profEnd()
{
  typeset -Ag _PROF_S
  typeset -Ag _PROF_E
  local name="${1:-main}"

  if [[ ! ${_PROF_S[$name]} ]]; then
    _profClear ${name}
    return
  fi

  _PROF_E[$name]=$(_profGetPrecTime)
}

function _profDiff()
{
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
# Get seconds since this script started.
#

function _profilerDiff() {
  local beg="${1}"
  local now=$(date +%s%N | cut -b1-13)

  echo $(bc <<< "scale=4;(${now}-${beg})/1000")
}


#
# Define fancy complete message display function.
#

function _dotZshWriteFancyComplete() {
  local columns=$(tput cols)
  local retStat='[ ok ]'
  local message="Loading ZSH configuration for %s@%s (took %s secs) ... "

  message="$(printf "${message}" "$USER" "$(hostname -s)" "$(_profilerDiff ${D_ZSH_TIME_START})")$(tput setaf 2) ${retStat}"

  #tput sgr0 && printf '%*s%s\n' $columns+5 "${message}" && tput sgr0
}


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

for inc in ${D_ZSH_CFG_ENABL_PATH}/??-???-*.(sh|z|zsh); do
  [[ ! -f "${inc}" ]] && _topLog 1 "    --> Failed to source $(basename ${inc})" && continue

  _topLog 1 "    --> Sourcing file $(basename ${inc})" && source "${inc}"
done


#
# Source all enabled includes by int-prefix order.
#

_topLog 1 "--> Loading enabled include files(s) from ${D_ZSH_INC_ENABL_PATH} ..."

for inc in ${D_ZSH_INC_ENABL_PATH}/??-???-*.(sh|z|zsh); do
  [[ ! -f "${inc}" ]] && _topLog 1 "    --> Failed to source $(basename ${inc})" && continue

  _topLog 1 "    --> Sourcing file $(basename ${inc})" && source "${inc}"
done


#
# Final cleanup.
#

_topLog 1 "--> Performing final cleanup pass ..."

D_ZSH_UNSET_VS=(D_ZSH_SELF_WHOS D_ZSH_SELF_HASH D_ZSH_SELF_VERS D_ZSH_SELF_REPO D_ZSH_STIO_BUFF D_ZSH_NAME D_ZSH_PATH D_ZSH_NAME D_ZSH_ROOT_PATH D_ZSH_LOAD_FILE D_ZSH_STIO_BUFF D_ZSH_INC_ENABL_PATH D_ZSH_INC_AVAIL_PATH D_ZSH_CFG_ENABL_PATH D_ZSH_CFG_AVAIL_PATH D_ZSH_BASE D_ZSH_STIO_BUFF D_ZSH_LIST_ALIAS D_ZSH_OPTS_ALIAS D_ZSH_LIST_EXPORT D_ZSH_LIST_ALIAS_NAME D_ZSH_LIST_ALIAS_CMDS)
D_ZSH_UNSET_FS=(_dotZshWhos _dotZshRepo _dotZshHash _dotZshVers _dotZshLoad _dotZshRepoByRemote _dotZshRepoByPath _dotZshAliasSSH _indent _topLog _incLog _warning)

_actLog "Unsetting global variables defined by this script ..." 1
for v in ${D_ZSH_UNSET_VS[@]}; do _actLog "Variable unset '${v}'"; done
_actLog "Unsetting global functions defined by this script ..." 1
for f in ${D_ZSH_UNSET_FS[@]}; do _actLog "Function unset '${f}'"; done

for v in ${D_ZSH_UNSET_VS[@]}; do eval "unset ${v}"; done
for f in ${D_ZSH_UNSET_FS[@]}; do eval "unset -f ${f}"; done

[[ ${D_ZSH_STIO_VLEV:--5} == -5 ]] && _dotZshWriteFancyComplete
