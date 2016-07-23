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
# Include Google Cloud SDK shell helpers.
#

for inc in "${HOME}/Downloads/google-cloud-sdk/path.zsh.inc" "${HOME}/Downloads/google-cloud-sdk/completion.zsh.inc"; do
  if [[ ! -f "${inc}" ]]; then
  	_warning "Sourcing file failure ${inc}"
  else
    source "${inc}" && _incLog 2 2 "Sourcing file ${inc}"
  fi
done

# EOF
