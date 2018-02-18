#!/usr/bin/env zsh

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#

D_ZSH_PLATFORM_SH_BIN="${HOME}/.platformsh/bin"
D_ZSH_PLATFORM_SH_SHELL_CONFIG="${HOME}/.platformsh/shell-config.rc"


#
# Add platform.sh binaries to PATH
#

_dotZshPathVariableAddition "${D_ZSH_PLATFORM_SH_BIN}" scripted


#
# Source platform.sh shell config
#

if [[ -f "${D_ZSH_PLATFORM_SH_SHELL_CONFIG}" ]]; then
  source "${D_ZSH_PLATFORM_SH_SHELL_CONFIG}" 2>/dev/null && _incLog 2 2 "Sourcing file ${inc}"
fi

# EOF
