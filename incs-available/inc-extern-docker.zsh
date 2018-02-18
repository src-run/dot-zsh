#!/usr/bin/env zsh

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#

D_ZSH_DOCKER_ENVIRONMENT="default"


#
# Setup docker-machine (if installed)
#

which docker-machine &> /dev/null

if [[ $? -eq 0 ]]; then
  eval "$(docker-machine env ${D_ZSH_DOCKER_ENVIRONMENT})"
fi

# EOF
