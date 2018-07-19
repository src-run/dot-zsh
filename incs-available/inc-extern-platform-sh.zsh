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
# Add platform.sh binaries to PATH
#

_add_env_path_dir "${_DZ_PLATFORM_SH_BIN}" scripted


#
# Source platform.sh shell config
#

if [[ -f "${_DZ_PLATFORM_SH_SHELL_CONFIG}" ]]; then
    source "${_DZ_PLATFORM_SH_SHELL_CONFIG}" 2>/dev/null && \
        _log_source 2 2 "Sourcing file ${inc}"
fi

# EOF
