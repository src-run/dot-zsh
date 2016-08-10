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
# Assign default verbose-level if $D_ZSH_STIO_VLEV is not yet defined.
#

if [[ ! ${D_ZSH_STIO_VLEV+x} ]]; then
  D_ZSH_STIO_VLEV=-5
fi

if [[ ${VERBOSE+x} ]]; then
  D_ZSH_STIO_VLEV=2
fi

if [[ ${VERY_VERBOSE+x} ]]; then
  D_ZSH_STIO_VLEV=4
fi

if [[ ${DEBUG+x} ]]; then
  D_ZSH_STIO_VLEV=10
fi

# EOF
