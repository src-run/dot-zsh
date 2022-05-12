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
# Setup python pip completion
#

_ifs_newlines
for eval in $(_cfg_get_array_values 'plugins.python_pip.initialize_evals'); do
    _log_action "Evaluating initialization script: '${eval}'"
    eval "$(eval "${eval}")"

    [[ $? -ne 0 ]] && \
        _log_warn "Failed evaluation of initialization script: '${eval}'"
done
_ifs_reset
