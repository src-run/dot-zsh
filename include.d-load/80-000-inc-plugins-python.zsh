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
# Setup python bin paths
#

for f in $(_cfg_get_array_values 'plugins.python.executable_paths'); do
    _add_env_path_dir "${f}" scripted
done
