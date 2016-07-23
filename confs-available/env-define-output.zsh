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
# Set log file path.
#

D_ZSH_LOGS_PATH="$HOME/.dot-zsh.log"


#
# Remove prior log file and start fresh if over 1000 lines.
#

[[ -f "${D_ZSH_LOGS_PATH}" ]] && [[ "$(wc -l "${D_ZSH_LOGS_PATH}" | cut -d' ' -f1)" -gt 1000 ]] && rm "${D_ZSH_LOGS_PATH}"


#
# Set default verbosity if variable is not yet defined.
#

if [[ ! ${D_ZSH_STIO_VLEV+x} ]]; then
  D_ZSH_STIO_VLEV=-5
fi


#
# Disable buffering and start outputing now that we have our config.
#

if [[ ${D_ZSH_STIO_BUFF} -eq -1 ]]; then
  unset D_ZSH_STIO_BUFF
fi


# EOF
