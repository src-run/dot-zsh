#!/usr/bin/env zsh

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#


D_ZSH_LOGS_PATH="./log.out"


#
# Set default verbosity if variable is not yet defined.
#

if [[ ! ${D_ZSH_STIO_VLEV+x} ]]; then
  D_ZSH_STIO_VLEV=0
fi


#
# Disable buffering and start outputing now that we have our config.
#

if [[ ${D_ZSH_STIO_BUFF+x} ]] && [[ ${D_ZSH_STIO_BUFF} -eq -1 ]]; then
  unset D_ZSH_STIO_BUFF
fi


# EOF
