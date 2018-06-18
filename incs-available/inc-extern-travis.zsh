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
# Source Travis shell completion script
#

if [[ -f "${D_ZSH_TRAVIS_SHELL_COMPLETION}" ]]; then
    source "${D_ZSH_TRAVIS_SHELL_COMPLETION}" 2>/dev/null && \
        _incLog 2 2 "Sourcing file ${D_ZSH_TRAVIS_SHELL_COMPLETION}"
fi

# EOF
