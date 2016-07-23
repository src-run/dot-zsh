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
# String padding routine.
#

function _indent() {
  local depth="${1:-2}" ; local padding

  for i in `seq 1 ${depth}`; do padding="    ${padding}"; done
  echo "${padding}"
}


#
# Define simple logger for include files.
#

function _incLog() {
  local i="$1" ; shift ; local l="$1" ; shift ; local m="$1" ; shift

  _topLog "${l}" "$(_indent ${i})--> ${m}" "$@"
}


#
# Define simple log warning.
#

function _warning() {
  typeset -g buffer_sout
  typeset -g buffer_flog

  local m="$1" ; shift
  local w="$(printf ${m} "$@")"

  buffer_flog+=("${w}")
  buffer_sout+=("${w}")

  if [[ "${D_ZSH_STIO_BUFF:=0}" -eq 0 ]]; then
    for line in "${buffer_sout[@]}"; do
      if [[ ! ${line} ]]; then
      	continue;
      fi

      >&2 echo -en "\n!!\n!! WARNING\n!!"
      >&2 echo " Message: \"${line}\""
      >&2 echo -en "!!\n\n"
    done

    buffer_sout=()
  fi

  if [[ "${D_ZSH_STIO_BUFF:=0}" -eq 0 ]] && [[ ${D_ZSH_LOGS_PATH:-x} ]] && [[ "${#buffer_flog}" -gt 0 ]]; then
    for line in "${buffer_flog[@]}"; do
      if [[ ! ${line} ]]; then
      	continue;
      fi

      _wrtLog "[!!WARNING!!:$(date +%s)] $(_indent 2)> ${line}$(_indent 4)# <-- [!!WARNING!!:$(date +%s)]"
    done

    buffer_flog=()
  fi
}

# EOF
