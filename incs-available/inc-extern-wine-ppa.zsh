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
# Add wine paths when installed from official PPA
#

_dotZshPathVariableAddition "/opt/wine-stable/bin" scripted
_dotZshPathVariableAddition "/opt/wine-devel/bin" scripted
_dotZshPathVariableAddition "/opt/wine-staging/bin" scripted
