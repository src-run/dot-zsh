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
# Define simple logger for include files.
#

function _incLog() {
  local i="$1" ; shift ; local l="$1" ; shift ; local m="$1" ; shift

  _topLog "${l}" "$(_indent ${i})--> ${m}" "$@"
}


#
# Define simple logger for include files.
#

function _actLog() {
  local m="${1}" ; shift ; local i="${1:-2}"

  if [[ "${1}" != "" ]]; then shift; fi

  _topLog 4 "$(_indent ${i})--- ${m}" "$@"
}


#
# Define simple log warning.
#

function _warning() {
  typeset -g b_warn_sout

  local d=$(date +%s)
  local c="!!WARNING!!"
  local l=2
  local m="$1" ; shift
  local w="$(printf ${m} "$@")"

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

function _dotZshPathVariableAddition() {
  local p=$(zsh -c "echo ${1}")
  local t="${2:-default}"

  if [[ -d "${p}" ]] && [[ ":$PATH:" != *":${p}:"* ]]; then
    PATH="${p}:${PATH}" && _incLog 2 2 "Prefixed 'PATH' with ${p} (${t})"
  fi
}


#
# Add temporary request for environment PATH addition
#

function _dotZshPathVariableAdditionRequest() {
  local p="${1}"

  if [[ ! -f "${D_ZSH_PATH_SCRIPTED_FILE}" ]]; then
    touch "${D_ZSH_PATH_SCRIPTED_FILE}" &> /dev/null
  fi

  echo "${p}" >> "${D_ZSH_PATH_SCRIPTED_FILE}" &> /dev/null
}


#
# Cleanup temporary environment PATH file
#

function _dotZshPathVariableAdditionRequestCleanup() {
  if [[ -f "${D_ZSH_PATH_SCRIPTED_FILE}" ]]; then
    rm "${D_ZSH_PATH_SCRIPTED_FILE}" &> /dev/null
  fi
}

# EOF
