#!/usr/bin/env zsh

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#

D_ZSH_CHRUBY_ENVIRONMENT="/usr/local/share/chruby/chruby.sh"
D_ZSH_CHRUBY_AUTO_SELECT="/usr/local/share/chruby/auto.sh"


#
# Source Chruby environment and auto-selector scripts
#

if [[ -f "${D_ZSH_CHRUBY_ENVIRONMENT}" ]]; then
  . "${D_ZSH_CHRUBY_ENVIRONMENT}" 2>/dev/null && _incLog 2 2 "Sourcing file ${inc}"
fi

if [[ -f "${D_ZSH_CHRUBY_AUTO_SELECT}" ]]; then
  . "${D_ZSH_CHRUBY_AUTO_SELECT}" 2>/dev/null && _incLog 2 2 "Sourcing file ${inc}"
fi


#
# Set Ruby 2.4.x as the default interpreter
#

which chruby &> /dev/null && chruby 2.4 || warning "Could not set chruby ruby version to 2.4"

# EOF
