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


#
# Define our list of variable to export.
#

typeset -a D_ZSH_LIST_EXPORT
D_ZSH_LIST_EXPORT=(ZSH PATH LANG EDITOR SSH_KEY_PATH)

#
# Define android sdk path
#

D_ZSH_ANDROID_SDK_BIN_PATH="${HOME}/Android/Sdk/platform-tools"


# EOF
