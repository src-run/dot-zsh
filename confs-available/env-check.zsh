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
# Enable shell-debugging if $_DOT_ZSH_DEBUG is defined and non-zero.
#

if [[ ${_DOT_ZSH_DEBUG+x} ]] && [[ ${_DOT_ZSH_DEBUG} -ne 0 ]]; then
  set -x;
fi


#
# Assign default verbose-level if $_DOT_ZSH_OUTPUT_VERBOSITY is not yet defined.
#

if [[ ! ${_DOT_ZSH_OUTPUT_VERBOSITY+x} ]]; then
  _DOT_ZSH_OUTPUT_VERBOSITY=0
fi


# EOF
