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

# EOF
