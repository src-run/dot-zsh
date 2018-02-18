#!/usr/bin/env zsh

#
# This file is part of the `sr`-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#

#
# List of the default directories to be added to environment PATH variable (if path exists)
#

D_ZSH_PATH_ADDITIONS_LIST=("${HOME}/bin" "${HOME}/scripts" "${HOME}/scripts/bin-enabled" "${HOME}/.composer/vendor/bin" "${HOME}/.phpenv/bin" "${HOME}/Android/Sdk/platform-tools")


#
# File containing list of the custom directoriesto be added to environment PATH variable (if path exists)
#

D_ZSH_PATH_ADDITIONS_FILE="${HOME}/.path-additions.list"


#
# Temporary file containing script-requested list of the custom directoriesto be added to environment PATH variable (if path exists)
#

D_ZSH_PATH_SCRIPTED_FILE="${HOME}/.path-additions-scripted.list"


# EOF
