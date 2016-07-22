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

if [[ ! ${_DOTZSH_VERBOSITY+x} ]]; then
  _DOTZSH_VERBOSITY=0
fi


# EOF
