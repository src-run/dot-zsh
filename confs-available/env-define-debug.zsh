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
# Enable shell debugging if variable is defined and non-zero.
#

if [[ ${_DOTZSH_DEBUG+x} ]] && [[ ${_DOTZSH_DEBUG} -ne 0 ]]; then
  set -x;
fi


# EOF
