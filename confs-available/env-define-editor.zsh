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
# Set our default editor depending on connection type.
#

if [[ -n ${SSH_CONNECTION} ]]; then
    EDITOR='vi'
else
    EDITOR='subl'
fi


# EOF
