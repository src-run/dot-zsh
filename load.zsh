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
# Define vars for script name, script dir path, and complete script file path.
#

_DOT_ZSH_NAME=${(%):-%x}
_DOT_ZSH_BASE=$(basename ${_DOT_ZSH_NAME})
_DOT_ZSH_PATH=${HOME}/.dot-zsh
_DOT_ZSH_CONFS_EN_PATH=${_DOT_ZSH_PATH}/confs-enabled


#
# Define simple logger function.
#

function _writeLog()
{
  typeset -g buffer
  local level="$1"; shift; local context="$USER/dot-zsh"; local message="$1"; shift

  (( _DOT_ZSH_OUTPUT_VERBOSITY < level )) && return 0
  buffer+=("$(printf '[%s:%s]  '${message} ${context} $(date +%s) "$@")")

  if [[ "${_DOT_ZSH_OUTPUT_BUFFER:=0}" -eq 0 ]]; then
    for line in "${buffer[@]}"; do [[ "${line}" ]] && echo "$line"; done
    buffer=()
  fi
}


#
# Define script version resolver function.
#

function _selfVersion()
{
  export version
  local -a strategies=("--exact-match" "--always")

  if [[ ${version:-x} == "x" ]]; then
    for s in "${strategies[@]}"; do
      version="$(cd ${_DOT_ZSH_PATH} && git describe --tag ${s} HEAD 2> /dev/null)"
      [[ ${#version} -gt 4 ]] && break
    done
  fi

  echo "${version}"
}


#
# Set print mode to log to buffer until config is loaded.
#

#if [[ ! ${_DOT_ZSH_OUTPUT_BUFFER+x} ]]; then
#  _DOT_ZSH_OUTPUT_BUFFER=-1
#fi


#
# Assign verbosity if variable is unset.
#

if [[ ! ${_DOT_ZSH_OUTPUT_VERBOSITY+x} ]]; then
  _DOT_ZSH_OUTPUT_VERBOSITY=0;
fi


#
# Let the user know we've begun and provide some environment context
#

_writeLog 2 '--> Resolved runtime configuration ...'
_writeLog 2 '    --> SRC_VERS = "git@%s"' "$(_selfVersion)"
_writeLog 2 '    --> SRC_ROOT = "%s"' "${_DOT_ZSH_NAME}"
_writeLog 2 '    --> SEC_VERS = "%s"' "${ZSH_VERSION}"
_writeLog 2 '    --> SEC_PATH = "%s"' "${SHELL}"


#
# Load our configuration files.
#

_writeLog 1 "--> Loading configuration file(s) from ${_DOT_ZSH_CONFS_EN_PATH} ..."

for inc in ${_DOT_ZSH_CONFS_EN_PATH}/??-???-*.(sh|z|zsh); do
  [[ ! -f "${inc}" ]] && _writeLog 1 "    --> Failed to source $(basename ${inc})" && continue

  _writeLog 1 "    --> Sourcing file $(basename ${inc})" && source "${inc}"
done


#
# Source all enabled includes by int-prefix order.
#

_writeLog 1 "--> Loading enabled include files(s) from ${_DOT_ZSH_INCS_EN_PATH} ..."

for inc in ${_DOT_ZSH_INCS_EN_PATH}/??-???-*.(sh|z|zsh); do
  [[ ! -f "${inc}" ]] && _writeLog 1 "    --> Failed to source $(basename ${inc})" && continue

  _writeLog 1 "    --> Sourcing file $(basename ${inc})" && source "${inc}"
done


#
# Final cleanup.
#

_writeLog 1 "--> Performing final var clean-up pass before completion ..."

unset _DOT_ZSH_OUTPUT_VERBOSITY
unset _DOT_ZSH_OUTPUT_BUFFER
unset _DOT_ZSH_NAME
unset -f _indent
unset -f _writeIncludeLog
unset -f _writeWarning
unset -f _writeLog
unset -f _selfVersion


# EOF
