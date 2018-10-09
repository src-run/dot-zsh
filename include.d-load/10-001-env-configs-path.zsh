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
# Add default directories to environment PATH variable
#

for p in $(_cfg_get_array_values 'configs.path.paths'); do
    _add_env_path_dir "${p}" default
done
