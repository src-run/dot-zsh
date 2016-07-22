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

function _indent()
{
  local depth="${1:-2}" ; local padding

  for i in `seq 1 ${depth}`; do padding="    ${padding}"; done
  echo "${padding}"
}


#
# Define simple logger for include files.
#

function _writeIncludeLog()
{
  local l="$1" ; local m="$2" ; shift ; shift

  _writeLog "${l}" "$(_indent 2)--> ${m}" "$@"
}


#
# Define simple log warning.
#

function _writeWarning()
{
  local m="$1"; shift ; local w="$(printf ${m} "$@")"

  >&2 echo -en "\n!!\n!! WARNING\n!!"
  >&2 echo " Message: \"${w}\""
  >&2 echo -en "!!\n\n"
}

# EOF
