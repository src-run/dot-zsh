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
# Setup golang environment
#

export GOROOT="${HOME}/golang/1.9"
_dotZshPathVariableAddition "${GOROOT}/bin"

# EOF
