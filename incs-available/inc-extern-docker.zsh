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
# Setup docker-machine (if installed)
#

which docker-machine &> /dev/null

if [[ $? -eq 0 ]]; then
    eval "$(docker-machine env ${_DZ_DOCKER_ENVIRONMENT})"
fi

# EOF
