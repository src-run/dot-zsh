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
# Register our custom completions.
#

fpath=(${_DZ_BASE}/resources/completions ${fpath}) && \
    _log_action 'FPath addition ${_DZ_BASE}/resources/completions'

autoload -U compinit && compinit &&
    _log_action "Evaluating 'autoload -U compinit && compinit'"


# EOF
