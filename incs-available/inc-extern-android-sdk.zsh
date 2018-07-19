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

_add_env_path_dir "${_DZ_ANDROID_SDK_BIN_PATH}" scripted && \
    _log_action "Added ${_DZ_ANDROID_SDK_BIN_PATH} to path"

# EOF
