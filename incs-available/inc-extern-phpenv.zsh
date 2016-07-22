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
# Include phpenv shell helpers.
#

_writeIncludeLog 2 'Evaluating $(phpenv init -)'

eval "$(phpenv init -)"

for inc in "${HOME}/.phpenv/completions/rbenv.zsh"; do
  if [[ ! -f "${inc}" ]]; then
  	_writeWarning "Sourcing file failure ${inc}"
  else
    source "${inc}" && _writeIncludeLog 2 "Sourcing file ${inc}"
  fi
done

# EOF
