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
# Root dir path and loader filepath.
#

_DOTZSH_ROOT_PATHNAME="$HOME/.dot-zsh"
_DOTZSH_LOAD_FILEPATH="$_DOTZSH_ROOT_PATHNAME/load.zsh"


#
# Dir path of available/enabled configuration paths.
#

_DOTZSH_CONFS_AV_PATHNAME="$_DOTZSH_ROOT_PATHNAME/confs-available"
_DOTZSH_CONFS_EN_PATHNAME="$_DOTZSH_ROOT_PATHNAME/confs-enabled"


#
# Dir path of avail/enable include paths.
#

_DOTZSH_INCLUDES_AV_PATHNAME="$_DOTZSH_ROOT_PATHNAME/incs-available"
_DOTZSH_INCLUDES_EN_PATHNAME="$_DOTZSH_ROOT_PATHNAME/incs-enabled"


# EOF
