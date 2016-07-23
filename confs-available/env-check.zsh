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
# Enable shell-debugging if $D_ZSH_DEBUG is defined and non-zero.
#

if [[ ${D_ZSH_DEBUG+x} ]] && [[ ${D_ZSH_DEBUG} -ne 0 ]]; then
  set -x;
fi


#
# Assign default verbose-level if $D_ZSH_STIO_VLEV is not yet defined.
#

if [[ ! ${D_ZSH_STIO_VLEV+x} ]]; then
  D_ZSH_STIO_VLEV=-5
fi


# EOF
