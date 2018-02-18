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

_incLog 2 2 'FPath addition ${D_ZSH_BASE}/resources/completions'
fpath=(${D_ZSH_BASE}/resources/completions ${fpath})

_incLog 2 2 "Evaluating 'autoload -U compinit && compinit'"
autoload -U compinit && compinit


# EOF
