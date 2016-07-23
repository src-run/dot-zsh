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
# Hard-code our LANG.
#
LANG=en_US.UTF-8


#
# Define vars for script name, script dir path, and complete script file path.
#

D_ZSH_NAME=${(%):-%x}
D_ZSH_BASE=$(basename ${D_ZSH_NAME})
D_ZSH_PATH=${HOME}/.dot-zsh
D_ZSH_CONFS_EN_PATH=${D_ZSH_PATH}/confs-enabled


#
# Define simple logger function.
#

function _topLog() {
  typeset -g buffer
  local level="$1"; shift; local context="$USER/dot-zsh"; local message="$1"; shift

  (( D_ZSH_OUTPUT_VERBOSITY < level )) && return 0
  buffer+=("$(printf '[%s:%s]  '${message} ${context} $(date +%s) "$@")")

  if [[ "${D_ZSH_OUTPUT_BUFFER:=0}" -eq 0 ]]; then
    for line in "${buffer[@]}"; do [[ "${line}" ]] && echo "$line"; done
    buffer=()
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
  local remote="$(cd ${D_ZSH_PATH} && git remote get-url origin | cut -d':' -f2)"

  echo "${remote:0:-4}"
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
# Define self version resolver function.
#

function _dotZshHash() {
  export D_ZSH_SELF_HASH
  local -a strategies=("--exact-match" "--always")

  if [[ ${D_ZSH_SELF_HASH:-x} == "x" ]]; then
    for s in "${strategies[@]}"; do
      D_ZSH_SELF_HASH="$(cd ${D_ZSH_PATH} && git describe --tag ${s} HEAD 3> /dev/null)" && [[ ${#D_ZSH_SELF_HASH} -gt 4 ]] && break
    done
  fi

  echo "${D_ZSH_SELF_HASH}"
}


#
# Define self author resolver function.
#

function _dotZshAuth() {
  export D_ZSH_SELF_AUTHOR

  if [[ ${D_ZSH_SELF_AUTHOR:-x} == "x" ]]; then
    D_ZSH_SELF_AUTHOR="$(cd ${D_ZSH_PATH} && git shortlog -ne | head -n1 | grep -o -P '^[^\(]+' | sed 's/ *$//')"
  fi

  echo "${D_ZSH_SELF_AUTHOR}"
}


#
# Define zsh name resolver function.
#

function _dotZshLoad() {
  echo "${D_ZSH_NAME}"
}


#
# Define zsh version resolver function.
#

function _sysZshSVer() {
  echo "${ZSH_VERSION}"
}


#
# Define zsh path resolver function.
#

function _sysZshPath() {
  echo "${SHELL}"
}


#
# Set print mode to log to buffer until config is loaded.
#

#if [[ ! ${D_ZSH_OUTPUT_BUFFER+x} ]]; then
#  D_ZSH_OUTPUT_BUFFER=-1
#fi


#
# Assign verbosity if variable is unset.
#

if [[ ! ${D_ZSH_OUTPUT_VERBOSITY+x} ]]; then
  D_ZSH_OUTPUT_VERBOSITY=10;
fi


#
# Let the user know we've begun and provide some environment context
#

_topLog 3 '--> Resolved runtime configuration ...'
_topLog 3 '    --> D_ZSH_SELF_NAME ...... %s' "$(_dotZshRepo)"
_topLog 3 '    --> D_ZSH_SELF_VERSION ... %s' "$(_dotZshHash)"
_topLog 3 '    --> D_ZSH_SELF_AUTHOR .... %s' "$(_dotZshAuth)"
_topLog 3 '    --> D_ZSH_SELF_LOADER .... %s' "$(_dotZshLoad)"
_topLog 3 '    --> ZSH_BINPATH ....... %s' "$(_sysZshPath)"
_topLog 3 '    --> ZSH_VERSION ....... %s' "$(_sysZshSVer)"


#
# Load our configuration files.
#

_topLog 1 "--> Loading configuration file(s) from ${D_ZSH_CONFS_EN_PATH} ..."

for inc in ${D_ZSH_CONFS_EN_PATH}/??-???-*.(sh|z|zsh); do
  [[ ! -f "${inc}" ]] && _topLog 1 "    --> Failed to source $(basename ${inc})" && continue

  _topLog 1 "    --> Sourcing file $(basename ${inc})" && source "${inc}"
done


#
# Source all enabled includes by int-prefix order.
#

_topLog 1 "--> Loading enabled include files(s) from ${D_ZSH_INCS_EN_PATH} ..."

for inc in ${D_ZSH_INCS_EN_PATH}/??-???-*.(sh|z|zsh); do
  [[ ! -f "${inc}" ]] && _topLog 1 "    --> Failed to source $(basename ${inc})" && continue

  _topLog 1 "    --> Sourcing file $(basename ${inc})" && source "${inc}"
done


#
# Final cleanup.
#

_topLog 1 "--> Performing final cleanup pass ..."

D_ZSH_UNSET_VS=(D_ZSH_SELF_AUTHOR D_ZSH_SELF_HASH D_ZSH_SELF_REPO D_ZSH_OUTPUT_VERBOSITY D_ZSH_OUTPUT_BUFFER D_ZSH_NAME D_ZSH_PATH D_ZSH_NAME D_ZSH_ROOT_PATH D_ZSH_LOAD_FILE D_ZSH_OUTPUT_BUFFER D_ZSH_INCS_EN_PATH D_ZSH_INCS_AV_PATH D_ZSH_CONFS_EN_PATH D_ZSH_CONFS_AV_PATH D_ZSH_BASE D_ZSH_OUTPUT_BUFFER D_ZSH_ALIAS_LIST D_ZSH_ALIAS_OPTS D_ZSH_EXPORTS)
D_ZSH_UNSET_FS=(_indent _topLog _incLog _warning _dotZshAuth _dotZshRepo _dotZshHash _dotZshLoad _dotZshRepoByRemote _dotZshRepoByPath _dotZshAliasSSH)

_incLog 1 4 "Unsetting global variables defined by this script ..."
for v in ${D_ZSH_UNSET_VS[@]}; do _incLog 2 4 "Variable unset '${v}'"; done
_incLog 1 4 "Unsetting global functions defined by this script ..."
for f in ${D_ZSH_UNSET_FS[@]}; do _incLog 2 4 "Function unset '${f}'"; done

for v in ${D_ZSH_UNSET_VS[@]}; do eval "unset ${v}"; done
for f in ${D_ZSH_UNSET_FS[@]}; do eval "unset -f ${f}"; done


# EOF
