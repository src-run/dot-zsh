#!/usr/bin/env zsh

#
# This file is part of the `src-run/dot-zsh` project.
#
# (c) Rob Frawley 2nd <rmf@src.run>
#
# For the full copyright and license information, view the LICENSE.md
# file distributed with this source code.
#


_DOT_ZSH_THIS="${(%):-%x}"
_DOT_ZSH_VARS=(_DOT_ZSH_PATH _DOT_ZSH_NAME _DOT_ZSH_ROOT_PATH _DOT_ZSH_LOAD_FILE _DOT_ZSH_OUTPUT_BUFFER _DOT_ZSH_INCS_EN_PATH _DOT_ZSH_INCS_AV_PATH _DOT_ZSH_CONFS_EN_PATH _DOT_ZSH_CONFS_AV_PATH)


#
# Loop over variable to unset and do so.
#

for var in ${_DOT_ZSH_VARS[@]}; do
  unset ${var} && _writeIncludeLog 3 "Unset \${${var}}"
done


#
# Clean up variables used in this file.
#

unset _DOT_ZSH_THIS
unset _DOT_ZSH_VARS

# EOF
