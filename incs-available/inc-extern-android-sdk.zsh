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
# Add Android SDK to PATH
#

_dotZshPathVariableAddition "${D_ZSH_ANDROID_SDK_BIN_PATH}" scripted && \
    _actLog "Added ${D_ZSH_ANDROID_SDK_BIN_PATH} to path"

# EOF
