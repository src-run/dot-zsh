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
# Temporary function to write error and exit.
#
function _writeErrorAndExit()
{
  local msg="$1"
  local ret="${2:=-1}"

  >&2 echo -en " [ Error ]\n $msg ...\n"
  >&2 echo -en " Exiting dot-zsh configuration."

  exit $ret;
}

#
# Ensure run in compatible shell type.
#

if [[ "${SHELL}" -ne /bin/zsh ]] && [[ "${SHELL}" -ne /usr/bin/zsh ]]; then
  _writeErrorAndExit "Unsupported shell found. This script can only be run from ZSH."
fi


#
# Ensure shell version can be determined.
#

if [[ ! ${ZSH_VERSION+x} ]]; then
  _writeErrorAndExit "The required global variable ZSH_VERSION is not undefined"
fi


#
# Ensure zsh version 5.x.x
#

if [[ ${ZSH_VERSION[0,1]} -ne 5 ]]; then
  _writeErrorAndExit "Unsupported shell version found. This script can only be run from ZSH ~5"
fi


#
# Cleanup after ourselves...
#

unset _writeErrorAndExit


# EOF
