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
# Add wine paths when installed from official PPA
#

for f in $(_config_read_array_vals 'extern["wine-hq"].executable_paths'); do
    _add_env_path_dir "${f}" scripted
done
