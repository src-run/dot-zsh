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
# Source chruby environment and auto-selector scripts
#

if [[ -f "${D_ZSH_CHRUBY_ENVIRONMENT}" ]]; then
    source "${D_ZSH_CHRUBY_ENVIRONMENT}" 2>/dev/null && \
        _incLog 2 2 "Sourcing file ${inc}"
fi

if [[ -f "${D_ZSH_CHRUBY_AUTO_SELECT}" ]]; then
    source "${D_ZSH_CHRUBY_AUTO_SELECT}" 2>/dev/null && \
        _incLog 2 2 "Sourcing file ${inc}"
fi


#
# Set Ruby 2.4.x as the default interpreter
#

which chruby &> /dev/null && \
    chruby 2.4 &> /dev/null || \
    _dzsh_warning "Could not set chruby ruby version to 2.4"

# EOF
