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

if [[ -f "${_DZ_CHRUBY_ENVIRONMENT}" ]]; then
    source "${_DZ_CHRUBY_ENVIRONMENT}" 2>/dev/null && \
        _log_source 2 2 "Sourcing file ${_DZ_CHRUBY_ENVIRONMENT}"
fi

if [[ -f "${_DZ_CHRUBY_AUTO_SELECT}" ]]; then
    source "${_DZ_CHRUBY_AUTO_SELECT}" 2>/dev/null && \
        _log_source 2 2 "Sourcing file ${_DZ_CHRUBY_AUTO_SELECT}"
fi


#
# Set Ruby 2.4.x as the default interpreter
#

chruby 2.4 &> /dev/null && \
    _log_action "Set ruby version 2.4 as default" || \
    _log_warn "Could not set chruby ruby version to 2.4"
