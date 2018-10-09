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
# Get the start time so we can profile performnce start to end.
#

_DZ_LOAD_TIME=$(_get_microtime)


#
# Define full-name, base-name, and path.
#

_DZ_NAME="${(%):-%x}"
_DZ_BASE="$(basename ${_DZ_NAME})"


#
# Define starting verbosity and io-buffering settings.
#

_DZ_IO_VERBOSITY=-5
_DZ_IO_BUFFERING=-1


#
# Define core, required include file paths.
#

_DZ_INC_CORE_SRCS=()
_DZ_INC_CORE_SRCS+=("${_DZ_PATH}/include.d-core/env-define-variables-intern.zsh")
_DZ_INC_CORE_SRCS+=("${_DZ_PATH}/include.d-core/env-define-functions-intern.zsh")
