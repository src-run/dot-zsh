#!/usr/bin/zsh

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#


#
# Root directory path and loader file path.
#
DOT_FILES_ROOT="$HOME/.dot-zsh"
DOT_FILES_INIT="$DOT_FILES_ROOT/loader.zsh"


#
# Define verbosity if not externally defined already.
#
if [[ ! ${_DOTZSH_VERBOSITY+x} ]]; then _DOTZSH_VERBOSITY=0; fi


#
# Available and enabled include directories.
#
DOT_FILES_INCS_AVAILABLE="$DOT_FILES_ROOT/incs-available"
DOT_FILES_INCS_ENABLED="$DOT_FILES_ROOT/incs-enabled"


# EOF
