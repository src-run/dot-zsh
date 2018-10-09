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
    v=$(_cfg_get_string 'plugins.docker.machine_env_type')
    eval "$(docker-machine env ${v})" && \
        _log_action "Docker machine environment '${v}' setup" || \
        _log_warn "Failed to setup docker machine '${v}' environment"
else
    _log_normal 1 \
        "        --- Skipping docker machine configuration (missing 'docker-machine' cmd)"
fi
