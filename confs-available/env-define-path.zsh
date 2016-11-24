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
# Amend PATH.
#

for p in "${HOME}/bin" "${HOME}/.composer/vendor/bin" "${HOME}/node_modules/.bin/"; do
  if [[ -d "${p}" ]]; then
    PATH="${p}:${PATH}"
  fi
done

# EOF
