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

fpath=(${D_ZSH_BASE}/resources/completions ${fpath}) && \
    _actLog 'FPath addition ${D_ZSH_BASE}/resources/completions'

autoload -U compinit && compinit &&
    _actLog "Evaluating 'autoload -U compinit && compinit'"


# EOF
