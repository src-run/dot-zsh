#!/usr/bin/env zsh

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#

D_ZSH_GNUPG_KEY="466839F8117362D877E438BE02B8697CE6AA381A"


#
# Export our default gnupg key and tty
#

export GPGKEY="${D_ZSH_GNUPG_KEY}"

#GPG_TTY="$(tty)""
#export GPG_TTY

# EOF
