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
# Source Google Cloud SDK path helper and completion scripts
#

if [[ -f "${D_ZSH_GCLOUD_PATH_FILE}" ]]; then
    source "${D_ZSH_GCLOUD_PATH_FILE}" 2>/dev/null && \
        _incLog 2 2 "Sourcing file ${inc}"
fi

if [[ -f "${D_ZSH_GCLOUD_SHELL_COMPLETION}" ]]; then
    source "${D_ZSH_GCLOUD_SHELL_COMPLETION}" 2>/dev/null && \
        _incLog 2 2 "Sourcing file ${inc}"
fi

# EOF
