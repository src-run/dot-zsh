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
# Set default verbosity if variable is not yet defined.
#

if [[ ! ${_DOT_ZSH_OUTPUT_VERBOSITY+x} ]]; then
  _DOT_ZSH_OUTPUT_VERBOSITY=0
fi


#
# Disable buffering and start outputing now that we have our config.
#

if [[ ${_DOT_ZSH_OUTPUT_BUFFER+x} ]] && [[ ${_DOT_ZSH_OUTPUT_BUFFER} -eq -1 ]]; then
  unset _DOT_ZSH_OUTPUT_BUFFER
fi


# EOF
